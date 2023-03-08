function fixwifi()
{
    sudo modprobe --remove ath10k_pci && sudo modprobe ath10k_pci
}
