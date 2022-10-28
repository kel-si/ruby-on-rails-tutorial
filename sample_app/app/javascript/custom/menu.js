// Menu manipulation

// Add toggle listeners to listen for clicks.
// "turbo:load" is page load event (DOMContentLoaded in JS)
document.addEventListener("turbo:load", function() {
    let account = document.querySelector("#account");
    account.addEventListener("click", function(event) {
        event.preventDefault();
        let menu = document.querySelector("#dropdown-menu");
        menu.classList.toggle("active");
    })
})