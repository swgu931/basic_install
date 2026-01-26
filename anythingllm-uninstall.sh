# Remove the AppImage
rm AnythingLLMDesktop.AppImage
 
# Remove the .desktop file
rm ~/.local/share/applications/anythingllmdesktop.desktop
 
# Remove the apparmor rules
sudo rm /etc/apparmor.d/anythingllmdesktop
 
# Remove the app data fully
rm -rf ~/.config/anythingllm-desktop
