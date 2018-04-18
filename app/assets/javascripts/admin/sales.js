document.addEventListener("turbolinks:load", function() {
	$(document).ready(function() {
		$("#current_time").click(function(){
			var dt = new Date();
			var time = dt.getHours() + ":" + dt.getMinutes() 
			$("#sale_created_at").val(time);
		});
	});
});
