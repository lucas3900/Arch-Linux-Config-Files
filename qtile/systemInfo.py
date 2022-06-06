from subprocess import check_output


def getFreeDiskSpace() -> str:
    mainDrive = str(check_output("df -h | grep /dev/nvme0n1p3", shell=True).strip(), "utf-8")
    attrs = mainDrive.split()
    numPercent = int(attrs[2][ :-1]) / int(attrs[1][ :-1]) * 100
    return str(round(numPercent, 1)) + '%'


def getNumUpdates() -> str:
    x = str(check_output("yay -Syup | wc -l", shell=True).strip(), "utf-8")
    return str(int(x) - 5)


def getNumBluetooth() -> str:
    x = str(check_output(
        """
        bluetoothctl paired-devices | cut -f2 -d' '|
        while read -r uuid
        do
            info=`bluetoothctl info $uuid`
            if echo "$info" | grep -q "Connected: yes"; then
                echo "$info" | grep "Name"
            fi
        done 
        """, shell=True).strip(), "utf-8")
    print(x)
    if x == "":
        return '0'
    else:
        return str(x.count('\n') + 1)


def getMemoryUsage() -> str:
    x = str(check_output("free | grep Mem:", shell=True).strip(), "utf-8")
    attrs  = x.split()
    memPercent = int(attrs[2]) / int(attrs[1]) * 100
    return str(round(memPercent, 1)) + '%'


def main():
    print(getNumUpdates())
    print(getFreeDiskSpace())
    print(getMemoryUsage())


if __name__ == "__main__":
    main()