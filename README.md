# Bare-Metal Bootloader in Docker  
A **lightweight, minimal bare-metal bootloader** written in **x86 Assembly**, running on **real hardware or in QEMU inside Docker**.

This project provides a **fully isolated Docker environment** for assembling and running a **bootloader without requiring an OS**.

---

##  **Features:**
**No OS Required** – Runs directly on hardware.  
**Minimal Setup** – No dependencies needed on the host machine.  
**Fully Dockerized** – NASM (for assembly) and QEMU (for execution) included in the container.  
**USB Bootable** – Can be flashed to a USB drive and booted on real hardware.  

---

## 📂 **Project Structure**
```
baremetal-bootloader/
├── src/                  # Source files
│   ├── bootloader.asm    # Core bootloader (loads kernel and modules)
│   ├── core.asm          # Core functionalities (prompt, input, output)
│   ├── commands/         # Separate folder for commands
│   │   ├── echo.asm      # "echo" command
│   │   ├── clear.asm     # "clear" command
│   │   ├── help.asm      # "help" command
├── bin/                  # Compiled output
│   ├── bootloader.bin
├── scripts/              # Build & run scripts
│   ├── build.sh
│   ├── run.sh
│   ├── entrypoint.sh
├── Dockerfile            # Minimal Docker setup
└── README.md             # Project documentation
```

---

##  **Setup Instructions**
### **1️⃣ Install Docker**
Make sure you have **Docker** installed. If not, install it from:  
🔗 [Docker Install Guide](https://docs.docker.com/get-docker/)  

---

### **2️⃣ Clone the Repository**
```bash
git clone https://github.com/javabrown/baremetal-bootloader.git
cd baremetal-bootloader
```

---

### **3️⃣ Make Scripts Executable**
```bash
chmod +x run_docker.sh scripts/*.sh
```

---

### **4️⃣ Build & Run the Docker Environment**
```bash
./run_docker.sh
```
 **What this does:**  
- Deletes any existing Docker image.  
- Builds a fresh Docker image.  
- Runs the container **with NASM and QEMU pre-installed**.  

---

##  **Building & Running the Bootloader**
### **5️⃣ Compile the Bootloader**
Inside Docker, run:
```bash
/app/scripts/build.sh
```
 **Output:**  
```
Compiling Bootloader...
 Bootloader compiled successfully! File saved in bin/bootloader.bin
```

---

### **6️⃣ Run the Bootloader in QEMU**
Inside Docker, run:
```bash
/app/scripts/run.sh
```
 **Expected Output in QEMU:**
```
Hello, World from Bare-Metal Bootloader!
```

---

##  **Booting on Real Hardware**
### **7️⃣ Flash to a USB Drive**
If you want to boot this on real hardware:  
```bash
sudo dd if=bin/bootloader.bin of=/dev/sdX bs=512 count=1
```
*(Replace `/dev/sdX` with your actual USB drive path.)*  

### **8️⃣ Reboot & Set USB as First Boot Device**
1. **Restart your computer**  
2. **Enter BIOS/UEFI** (Press **F2, F12, DEL, ESC**, depending on the manufacturer)  
3. **Set the USB drive as the first boot device**  
4. **Save and exit**  

💡 **If successful, you will see the message on your screen!**

---

## ** Next Steps**
Would you like to:
- **Handle keyboard input in the bootloader?**
- **Load a kernel after boot?**
- **Port this to ARM for mobile devices?**

---

##  **Troubleshooting**
 **Getting "stat /app/build.sh: no such file or directory" error?**  
 **Make sure the scripts are mounted inside Docker:**  
```bash
-v $(pwd)/scripts:/app/scripts
```
 **Ensure the scripts have execution permissions:**  
```bash
chmod +x scripts/*.sh
```

---

##  **Contribute & Support**
 Feel free to **fork this repo**, submit **PRs**, or ask **questions** in the Issues section!  

 **Follow for more projects:**  https://github.com/javabrown

---

## ** License**
This project is **open-source** under the **MIT License**.  



