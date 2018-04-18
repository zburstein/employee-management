document.addEventListener("turbolinks:load", function() {

	$(document).ready(function() {
		$("#employee_position_id").change(function(){
			$("#employee_wage").val($(this).find(":selected").data("default-wage"));
		});
	});
});