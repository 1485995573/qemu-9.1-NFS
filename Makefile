# 定义变量
DTB = ./vexpress-v2p-ca9.dtb
KERNEL = ./zImage
ROOTFS = ./rootfs
QEMU = qemu-system-arm

# 默认目标
.PHONY: all
all: run

# 配置 tap0
.PHONY: setup_tap
setup_tap:
	sudo ip tuntap add dev tap0 mode tap
	sudo ip link set tap0 up
	sudo ip addr add 192.168.3.101/24 dev tap0

# 运行 QEMU
.PHONY: run
run:
	$(QEMU) -cpu cortex-a9 -smp 4 -m 512 \
	    -machine type=vexpress-a9 -serial mon:stdio \
	    -kernel $(KERNEL) \
	    -dtb $(DTB) \
	    -netdev tap,id=net0,ifname=tap0,script=no,downscript=no \
	    -device virtio-net-device,netdev=net0 \
	    -append "root=/dev/nfs rw nfsroot=192.168.3.162:/home/cwb/qemu_9.1/img/rootfs ip=192.168.3.106 console=ttyAMA0" \
	    -nographic

# 清理
.PHONY: clean
clean:
	@echo "Nothing to clean."
