#include <dirent.h>
#include <fcntl.h>
#include <linux/fb.h>
#include <linux/input.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <unistd.h>

#define C_BG      0xFF141022
#define C_CARD    0xFF231B3D
#define C_CARD_HI 0xFF35285C
#define C_ACCENT  0xFF8B5CF6
#define C_SILVER  0xFFE5E7EB
#define C_MUTED   0xFF9CA3AF
#define C_OK      0xFFA78BFA
#define C_ERR     0xFFF87171

static uint32_t *fb, *buf;
static int dirty = 1;
static int w = 1080, h = 2400, stride = 1080;
static char status_line[128] = "READY - ONLY ED25519 SIGNED IMAGES ACCEPTED";
static char files[32][128];
static int file_count = 0, mode = 0, sel = 0;

static const uint8_t font8x8[96][8] = {
    [' ' - 32] = {0},
    ['-' - 32] = {0,0,0,0x7E,0,0,0,0},
    ['.' - 32] = {0,0,0,0,0,0,0x18,0x18},
    ['/' - 32] = {0x02,0x04,0x08,0x10,0x20,0x40,0,0},
    [':' - 32] = {0,0x18,0x18,0,0x18,0x18,0,0},
    ['[' - 32] = {0x3C,0x30,0x30,0x30,0x30,0x30,0x3C,0},
    [']' - 32] = {0x3C,0x0C,0x0C,0x0C,0x0C,0x0C,0x3C,0},
    ['_' - 32] = {0,0,0,0,0,0,0,0xFF},
    ['0' - 32] = {0x3C,0x66,0x6E,0x76,0x66,0x66,0x3C,0},
    ['1' - 32] = {0x18,0x38,0x18,0x18,0x18,0x18,0x7E,0},
    ['2' - 32] = {0x3C,0x66,0x06,0x0C,0x30,0x60,0x7E,0},
    ['3' - 32] = {0x3C,0x66,0x06,0x1C,0x06,0x66,0x3C,0},
    ['4' - 32] = {0x0C,0x1C,0x3C,0x6C,0x7E,0x0C,0x0C,0},
    ['5' - 32] = {0x7E,0x60,0x7C,0x06,0x06,0x66,0x3C,0},
    ['6' - 32] = {0x3C,0x60,0x7C,0x66,0x66,0x66,0x3C,0},
    ['7' - 32] = {0x7E,0x66,0x0C,0x18,0x18,0x18,0x18,0},
    ['8' - 32] = {0x3C,0x66,0x66,0x3C,0x66,0x66,0x3C,0},
    ['9' - 32] = {0x3C,0x66,0x66,0x3E,0x06,0x66,0x3C,0},
    ['A' - 32] = {0x18,0x3C,0x66,0x7E,0x66,0x66,0x66,0},
    ['B' - 32] = {0x7C,0x66,0x66,0x7C,0x66,0x66,0x7C,0},
    ['C' - 32] = {0x3C,0x66,0x60,0x60,0x60,0x66,0x3C,0},
    ['D' - 32] = {0x78,0x6C,0x66,0x66,0x66,0x6C,0x78,0},
    ['E' - 32] = {0x7E,0x60,0x60,0x78,0x60,0x60,0x7E,0},
    ['F' - 32] = {0x7E,0x60,0x60,0x78,0x60,0x60,0x60,0},
    ['G' - 32] = {0x3C,0x66,0x60,0x6E,0x66,0x66,0x3E,0},
    ['H' - 32] = {0x66,0x66,0x66,0x7E,0x66,0x66,0x66,0},
    ['I' - 32] = {0x3C,0x18,0x18,0x18,0x18,0x18,0x3C,0},
    ['K' - 32] = {0x66,0x6C,0x78,0x70,0x78,0x6C,0x66,0},
    ['L' - 32] = {0x60,0x60,0x60,0x60,0x60,0x60,0x7E,0},
    ['M' - 32] = {0x63,0x77,0x7F,0x6B,0x63,0x63,0x63,0},
    ['N' - 32] = {0x66,0x76,0x7E,0x7E,0x6E,0x66,0x66,0},
    ['O' - 32] = {0x3C,0x66,0x66,0x66,0x66,0x66,0x3C,0},
    ['P' - 32] = {0x7C,0x66,0x66,0x7C,0x60,0x60,0x60,0},
    ['R' - 32] = {0x7C,0x66,0x66,0x7C,0x78,0x6C,0x66,0},
    ['S' - 32] = {0x3C,0x66,0x60,0x3C,0x06,0x66,0x3C,0},
    ['T' - 32] = {0x7E,0x18,0x18,0x18,0x18,0x18,0x18,0},
    ['U' - 32] = {0x66,0x66,0x66,0x66,0x66,0x66,0x3C,0},
    ['V' - 32] = {0x66,0x66,0x66,0x66,0x66,0x3C,0x18,0},
    ['W' - 32] = {0x63,0x63,0x63,0x6B,0x7F,0x77,0x63,0},
    ['X' - 32] = {0x66,0x66,0x3C,0x18,0x3C,0x66,0x66,0},
    ['Y' - 32] = {0x66,0x66,0x66,0x3C,0x18,0x18,0x18,0},
};

static void fill_rect(int x, int y, int rw, int rh, uint32_t col) {
    for (int py = y; py < y + rh && py < h; py++)
        if (py >= 0)
            for (int px = x; px < x + rw && px < w; px++)
                if (px >= 0) buf[py * stride + px] = col;
}

static void draw_text(int x, int y, const char *s, uint32_t col, int sc) {
    for (; *s; s++, x += 9 * sc) {
        char c = *s;
        if (c >= 'a' && c <= 'z') c -= 32;
        if (c < 32 || c > 127) continue;
        const uint8_t *g = font8x8[c - 32];
        for (int r = 0; r < 8; r++)
            for (int b = 0; b < 8; b++)
                if (g[r] & (0x80 >> b))
                    fill_rect(x + b * sc, y + r * sc, sc, sc, col);
    }
}

static void scan_sdcard(void) {
    file_count = 0;
    DIR *d = opendir("/sdcard");
    if (!d) { snprintf(status_line, sizeof(status_line), "SDCARD NOT MOUNTED"); return; }
    struct dirent *de;
    while ((de = readdir(d)) && file_count < 32) {
        if (de->d_name[0] == '.') continue;
        snprintf(files[file_count++], 128, "%s", de->d_name);
    }
    closedir(d);
}

static void backup_to_sdcard(void) {
    snprintf(status_line, sizeof(status_line), "BACKING UP BOOT AND EFS TO SDCARD...");
    int rc = system(
        "mkdir -p /sdcard/minsktoo-backup && "
        "for p in boot_a boot_b dtbo_a dtbo_b persist modemst1 modemst2; do "
        "dev=/dev/disk/by-partlabel/$p; [ -b \"$dev\" ] || dev=/dev/block/by-name/$p; "
        "[ -b \"$dev\" ] && dd if=\"$dev\" of=\"/sdcard/minsktoo-backup/$p.img\" bs=4M status=none; "
        "done && sync");
    snprintf(status_line, sizeof(status_line), rc == 0 ? "BACKUP SAVED TO /SDCARD/MINSKTOO-BACKUP" : "BACKUP FAILED");
}

static void flash_selected(void) {
    if (file_count == 0) return;
    char cmd[512], path[256];
    snprintf(path, sizeof(path), "/sdcard/%s", files[sel]);
    const char *part = (strstr(files[sel], "rootfs") || strstr(files[sel], "userdata")) ? "userdata" : "boot_a";
    snprintf(cmd, sizeof(cmd), "/usr/sbin/minsktoo-recover '%s' '%s'", path, part);
    int rc = system(cmd);
    snprintf(status_line, sizeof(status_line), rc == 0 ? "VERIFIED AND FLASHED SUCCESSFULLY" : "REJECTED: INVALID SIGNATURE");
}

static void render(void) {
    fill_rect(0, 0, w, h, C_BG);
    fill_rect(0, 0, w, 180, C_CARD);
    fill_rect(0, 174, w, 6, C_ACCENT);
    draw_text(48, 48, "MINSKTOO RECOVERY", C_SILVER, 4);
    draw_text(48, 112, "ED25519 SIGNED RECOVERY - XT2115-1", C_OK, 2);

    if (mode == 0) {
        const char *items[4] = {
            "1. INSTALL SIGNED IMAGE",
            "2. BACKUP SYSTEM TO SDCARD",
            "3. BROWSE SDCARD FILES",
            "4. REBOOT SYSTEM"
        };
        for (int i = 0; i < 4; i++) {
            int y = 260 + i * 280;
            fill_rect(48, y, w - 96, 230, i == sel ? C_CARD_HI : C_CARD);
            fill_rect(48, y, 12, 230, i == sel ? C_ACCENT : C_MUTED);
            draw_text(90, y + 95, items[i], C_SILVER, 3);
        }
    } else {
        fill_rect(48, 220, w - 96, 110, C_CARD_HI);
        draw_text(80, 255, "BACK TO MAIN MENU", C_ACCENT, 3);
        for (int i = 0; i < file_count && i < 10; i++) {
            int y = 360 + i * 140;
            char sig[256];
            snprintf(sig, sizeof(sig), "/sdcard/%s.sig", files[i]);
            int signed_ok = (access(sig, F_OK) == 0);
            fill_rect(48, y, w - 96, 115, i == sel ? C_CARD_HI : C_CARD);
            draw_text(80, y + 40, files[i], signed_ok ? C_SILVER : C_MUTED, 3);
            draw_text(w - 310, y + 44, signed_ok ? "[SIGNED]" : "[LOCKED]", signed_ok ? C_OK : C_ERR, 2);
        }
    }

    fill_rect(48, h - 220, w - 96, 160, C_CARD);
    fill_rect(48, h - 220, w - 96, 4, C_SILVER);
    draw_text(72, h - 165, status_line, C_SILVER, 2);
    memcpy(fb, buf, (size_t)h * stride * 4);
}

int main(void) {
    int fbfd = open("/dev/fb0", O_RDWR);
    if (fbfd < 0) return 1;
    struct fb_var_screeninfo vinfo;
    struct fb_fix_screeninfo finfo;
    ioctl(fbfd, FBIOGET_VSCREENINFO, &vinfo);
    ioctl(fbfd, FBIOGET_FSCREENINFO, &finfo);
    w = vinfo.xres; h = vinfo.yres; stride = finfo.line_length / 4;
    fb = mmap(NULL, finfo.smem_len, PROT_READ | PROT_WRITE, MAP_SHARED, fbfd, 0);
    buf = malloc((size_t)h * stride * 4);

    int evfd = -1;
    for (int i = 0; i < 8; i++) {
        char p[32]; snprintf(p, sizeof(p), "/dev/input/event%d", i);
        int fd = open(p, O_RDONLY | O_NONBLOCK);
        if (fd >= 0) { evfd = fd; break; }
    }

    int ty = 0;
    for (;;) {
        if (dirty) { render(); dirty = 0; }
        struct input_event ev;
        if (evfd >= 0 && read(evfd, &ev, sizeof(ev)) == sizeof(ev)) {
            dirty = 1;
            if (ev.type == EV_ABS && ev.code == ABS_MT_POSITION_Y) ty = ev.value;
            if ((ev.type == EV_KEY && ev.code == BTN_TOUCH && ev.value == 0) ||
                (ev.type == EV_KEY && ev.code == KEY_POWER && ev.value == 1)) {
                if (mode == 0) {
                    int idx = (ev.code == KEY_POWER) ? sel : (ty - 260) / 280;
                    if (idx == 0) { scan_sdcard(); mode = 1; sel = 0; }
                    else if (idx == 1) { backup_to_sdcard(); }
                    else if (idx == 2) { scan_sdcard(); mode = 2; sel = 0; }
                    else if (idx == 3) { sync(); system("reboot"); }
                } else {
                    if (ty < 340) { mode = 0; sel = 0; }
                    else {
                        int idx = (ty - 360) / 140;
                        if (idx >= 0 && idx < file_count) {
                            sel = idx;
                            if (mode == 1) flash_selected();
                        }
                    }
                }
            }
            if (ev.type == EV_KEY && ev.code == KEY_VOLUMEDOWN && ev.value == 1) sel = (sel + 1) % 4;
            if (ev.type == EV_KEY && ev.code == KEY_VOLUMEUP && ev.value == 1) sel = (sel + 3) % 4;
        }
        usleep(30000);
    }
    return 0;
}
