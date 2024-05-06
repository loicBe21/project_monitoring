
// JavaScript to change favicon dynamically
export function changeFaviconByTheme() {
    const isDarkMode = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
    const isLightMode = window.matchMedia && window.matchMedia('(prefers-color-scheme: light)').matches;
    const favicon = document.querySelector("link[rel='icon']");

    if (isDarkMode) {
        favicon.href = 'https://test.monitoring.phidia.fr/images/profiles/Mgbi-profile-light.png';
        console.log("The theme is Dark and it's", isDarkMode)
    } else {
        favicon.href = 'https://test.monitoring.phidia.fr/images/profiles/Mgbi-profile.png';
        console.log("The theme is Light and it's", isLightMode)
    }
}

// Call the function when the page loads
window.onload = function() {
    changeFaviconByTheme();
}

// Listen for theme changes and update the favicon accordingly
window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', () => {
    changeFaviconByTheme();
});