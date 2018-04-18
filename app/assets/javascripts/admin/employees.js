document.addEventListener("turbolinks:load", function() {
	$(document).ready(function() {
		$("#employees-table").on("click", ".employee-row", function(){
			window.location.href = "/admin/employees/" + $(this).data("target") + "?time=-7";
		});
	});
});