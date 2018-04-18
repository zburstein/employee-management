document.addEventListener("turbolinks:load", function() {
	$(document).ready(function() {
		//when click on a row make ajax call to populate teh sales modal and then open it
		$("#shifts_table").on("click", ".shift-row", function(){
			//ajax call to get the sales of that shift
			$.ajax({
			    type: "GET",// GET in place of POST
			    url: "/admin/shift/" + $(this).data("target") + "/sales",
				dataType: 'script',
				async: false
			});
			$("#salesIndexModal").modal('show');
		});

		//only remove the inner modal if closing the inner one. Without this ist removes both
		$("body").on("click", ".inner-modal", function(){
			$($(this).data("target")).modal('toggle');
		});

		//ensure the backdrop is removed if outer modal is closed. 
		//the nested modal creates issues that need some customization
		$('#salesIndexModal').on('hidden.bs.modal', function (e) {
			
			//if the sales modal is no longer showing  then can remove backdrop. Need this chekc becasue this event is called when inner modal is closed
			if(!$("#salesIndexModal").hasClass("show")){
				$(".modal-backdrop").remove();
			}
			
		});

		$("#shifts_table").on("click", ".admin-function", function(e){
			e.stopPropagation();
		});


	});
});