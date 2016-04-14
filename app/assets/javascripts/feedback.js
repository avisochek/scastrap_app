// this is the id of the form
$(function(){
$("#feedbackForm").submit(function(e) {
    var url = "feedback"; // the script where you handle the form input.

    $.ajax({
           type: "POST",
           url: url,
           data: $("#feedbackForm").serialize(), // serializes the form's elements.
           success: function(response)
           {
               $("#feedbackResponseMessage").text(response["message"]); // show response from the php script.
           }
         });

    e.preventDefault(); // avoid to execute the actual submit of the form.
});
});
