include common.mk

LIMINE_DIR := $(INCLUDE_DIR)/limine
LIMINE_TOOL := $(LIMINE_DIR)/limine

SRCS := $(shell find $(SRC_DIR) \( -name "*.c" -o -name "*.cpp" -o -name "*.asm" \) -print)

OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)
.PHONY: all fetchDeps run clean

all: $(ISO)

fetchDeps:
	@echo "[DEPS] Fetching Limine"
	@mkdir -p $(INCLUDE_DIR)
	@rm -rf $(LIMINE_DIR)
	@git clone --branch=v11.x-binary --depth=1 https://codeberg.org/Limine/Limine.git $(LIMINE_DIR)
	@make -C $(LIMINE_DIR)
	@rm -rf $(LIMINE_DIR)/.git
	@wget https://codeberg.org/Limine/limine-protocol/raw/branch/trunk/include/limine.h -O $(LIMINE_DIR)/limine.h

$(BUILD_DIR)/kernel.elf: $(ARCH_DIR)/linker.ld $(OBJS)
	@mkdir -p $(dir $@)
	$(VLD) $(LDFLAGS) -T $< $(OBJS) -o $@

$(ISO): limine.conf $(LIMINE_TOOL) $(BUILD_DIR)/kernel.elf
	@echo "[ISO] Creating bootable image..."
	@rm -rf $(ISODIR)

	@mkdir -p $(ISODIR)/boot/limine
	@mkdir -p $(ISODIR)/EFI/BOOT

	@cp $(BUILD_DIR)/kernel.elf $(ISODIR)/boot/kernel.elf
	@cp limine.conf $(ISODIR)/boot/limine/

	@cp $(LIMINE_DIR)/limine-bios.sys $(ISODIR)/boot/limine/
	@cp $(LIMINE_DIR)/limine-bios-cd.bin $(ISODIR)/boot/limine/
	@cp $(LIMINE_DIR)/limine-uefi-cd.bin $(ISODIR)/boot/limine/

	@cp $(LIMINE_DIR)/BOOTIA32.EFI $(ISODIR)/EFI/BOOT/
	@cp $(LIMINE_DIR)/BOOTX64.EFI $(ISODIR)/EFI/BOOT/

	@xorriso -as mkisofs \
		-b boot/limine/limine-bios-cd.bin \
		-no-emul-boot \
		-boot-load-size 4 \
		-boot-info-table \
		--efi-boot boot/limine/limine-uefi-cd.bin \
		-efi-boot-part \
		--efi-boot-image \
		--protective-msdos-label \
		-iso-level 3 \
		-rational-rock \
		$(ISODIR) \
		-o $@

	@$(LIMINE_TOOL) bios-install $@
	@echo "[OK] $@ created"

disk:
	@mkdir -p $(DISK_DIR)
	@if [ -f $(DISK_IMG) ]; then \
		rm $(DISK_IMG); \
	fi
	@qemu-img create -f raw $(DISK_IMG) 256M
	@echo "[DISK] created $(DISK_IMG)"

run: $(ISO)
	@qemu-system-x86_64 \
		-M pc \
		-cpu max \
		-m 512M \
		-cdrom $(ISO) \
		-drive if=pflash,format=raw,readonly=on,file=third_party/uefi/OVMF_CODE.fd \
		-drive if=pflash,format=raw,file=third_party/uefi/OVMF_VARS.fd \
		-drive file=$(DISK_IMG),format=raw,if=ide,index=0 \
		-serial stdio \
		-vga std \
		-display default

$(BUILD_DIR)/%.c.o: %.c
	@mkdir -p $(dir $@)
	$(VCC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/%.cpp.o: %.cpp
	@mkdir -p $(dir $@)
	$(VCXX) $(CXXFLAGS) -c $< -o $@

$(BUILD_DIR)/%.asm.o: %.asm
	@mkdir -p $(dir $@)
	$(VAS) $(ASFLAGS) $< -o $@

clean:
	@echo "[CLR] Cleaning..."
	@rm -rf $(BUILD_DIR)
	@rm -rf $(ISODIR)
	@rm -f $(ISO)
	@echo "[OK]"
