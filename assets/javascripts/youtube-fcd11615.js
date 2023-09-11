// Get all of the videos
let videos = document.querySelectorAll('[data-youtube]');

// Progressively enhance them
for (let video of videos) {
	// Get the video ID
	//let id = new URL(video.href).searchParams.get('v');
	let id = video.getAttribute('data-youtube');

	// Add the ID to the data-youtube attribute
	//video.setAttribute('data-youtube', id);

	// Add a role of button
	video.setAttribute('role', 'button');

	// Add a thumbnail
	//video.innerHTML =
	//	`<img alt="" src="https://img.youtube.com/vi/${id}/maxresdefault.jpg"><br>
	//	${video.textContent}`;
	//video.insertAdjacentHTML('afterbegin', `<img alt="" src="https://img.youtube.com/vi/${id}/maxresdefault.jpg">`);
	video.innerHTML = `<img alt="" class="card-img-top" src="https://img.youtube.com/vi/${id}/maxresdefault.jpg">`;
}

/**
 * Handle click events on the video thumbnails
 * @param  {Event} event The event object
 */
function clickHandler (event) {
	// Get the video link
	let link = event.target.closest('[data-youtube]');
	if (!link) return;
	// Prevent the URL from redirecting users
	event.preventDefault();

	// Get the video ID
	let id = link.getAttribute('data-youtube');

	// Create the player
	let player = document.createElement('div');
	player.innerHTML = `<iframe class="card-img-top" src="https://www.youtube-nocookie.com/embed/${id}?autoplay=1&disablekb=1&iv_load_plicy=4&loop=1&modestbranding=1&rel=0" allowfullscreen sandbox="allow-same-origin allow-scripts" referrerpolicy="no-referrer" crossorigin="anonymous"></iframe>`;

	// Inject the player into the UI
	link.replaceWith(player);
}

// Detect clicks on the video thumbnails
document.addEventListener('click', clickHandler);
