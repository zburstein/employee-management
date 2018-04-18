document.addEventListener("turbolinks:load", function() {

	$(document).ready(function() {

		$('#myModal').on('shown.bs.modal', function () {
			$('#myInput').focus()
		});

		//on sale submit hide the modal and clear the form
		/*
		//this is clearing the  form before submit
		$("#new_sale").submit(function(){
			$('#saleModal').modal('hide');
			$('#new_sale')[0].reset();
		});
		*/
		
		$("#new_sale").on("ajax:success", function(e, data, status, xhr){
			$('#saleModal').modal('hide');
			$('#new_sale')[0].reset();
		});
		$("#new_sale").on("ajax:failure", function(e, data, status, xhr){
			alert("Error occured");
		});
		$("#tipModalClose").click(function(){
			$("#tipModalBody").html("");
		});

	});
});