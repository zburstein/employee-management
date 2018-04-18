document.addEventListener("turbolinks:load", function() {
	$(document).ready(function() {

		//when a new week is selected ajax call to use those weeks
		$("#weeks_select").change(function(){
			$.ajax({
			    type: "GET",// GET in place of POST
			    url: "/admin/weeks/" + $(this).val(),
			    data: {employee_id: $("#employee_select").val()},
				dataType: 'script'
			});
		});

		//when a new employee is selected ajax call to get there weekly payrols
		$("#employee_select").change(function(){
			$.ajax({
			    type: "GET",// GET in place of POST
			    url: "/admin/weeks/" + $("#weeks_select").val(),
			    data: {employee_id: $(this).val()},
				dataType: 'script'
			});
		});


		//when row is clicked on, navigate to that payroll
		$( "#weekly_payrolls_table" ).on( "click", ".payroll-row", function() {
			window.location.href = "/admin/weekly_payrolls/" + $(this).data("target");
		});

		//if employee a tag is clicked on, dont navigate to payroll, but instead to the employee profile in the a tag's href
		$("#weekly_payrolls_table").on("click", ".employee-link", function(e){
			e.stopPropagation();
		});
	});
});
