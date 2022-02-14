//= require popper
//= require bootstrap

function updateStorage(target) {
	var previous = localStorage.getItem(target.id);
	var next = previous ^ true;
  localStorage.setItem(target.id, next);

	if (next == 1) target.style.opacity = .4;
	else target.style.opacity = 1.0;
}

document.addEventListener('DOMContentLoaded', function(){
	document.querySelectorAll('.card').forEach(cardElem => {
		if (localStorage.getItem(cardElem.id) == 1) cardElem.style.opacity = .4;
		cardElem.addEventListener('click', () => updateStorage(cardElem));
	});
});
