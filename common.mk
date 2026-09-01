OS_NAME ?= develOS
ARCH ?= x86_64
ARCH_UPPER := $(shell echo $(ARCH) | tr a-z A-Z)

# Build toolchain
CC := $(ARCH)-elf-gcc
CXX := $(ARCH)-elf-g++
LD := $(ARCH)-elf-ld
AS := nasm
OBJCOPY := $(ARCH)-elf-objcopy
VCC  = @echo "   CC   $<" && $(CC)
VCXX = @echo "   CXX  $<" && $(CXX)
VAS  = @echo "   AS   $<" && $(AS)
VLD  = @echo "   LD   $@" && $(LD)

# Compiler Flags
ifeq ($(ARCH),x86_64)
ARCH_FLAGS := -m64 -march=x86-64 -mno-80387 -mno-mmx -mno-sse -mno-sse2 \
              -mno-red-zone -mcmodel=kernel
else ifeq ($(ARCH),aarch64)
ARCH_FLAGS := -mgeneral-regs-only -mcmodel=large
endif

COMMON_FLAGS += -I $(INCLUDE_DIR) -I $(SRC_DIR) -I src/ -I $(SRC_DIR)/kernel/ \
                -I $(ARCH_DIR) \
                -ffreestanding -fno-stack-protector -fno-lto \
                -fno-PIE -fno-pic $(ARCH_FLAGS) \
                -Wall -Wextra -Wpedantic -DARCH_$(ARCH_UPPER) \
                -mno-sse -mno-sse2

CFLAGS ?= $(COMMON_FLAGS) -std=c23
CXXFLAGS ?= $(COMMON_FLAGS) -std=c++17 -fno-exceptions -fno-rtti
LDFLAGS ?= -nostdlib -static -no-pie -z text -z max-page-size=0x1000
ASFLAGS ?= -f elf64

# Directories and files
SRC_DIR := src
USERSPACE_DIR = user
ARCH_DIR := $(SRC_DIR)/kernel/arch/$(ARCH)
USERSPACE_BUILD = build/userspace
BUILD_DIR := build
DISK_DIR := dsk
DISK_IMG := $(DISK_DIR)/disk.img
INCLUDE_DIR := third_party
ISODIR := $(BUILD_DIR)/isodir
ISO := $(BUILD_DIR)/$(OS_NAME).iso
