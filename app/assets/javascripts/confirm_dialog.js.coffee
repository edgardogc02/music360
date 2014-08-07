$.rails.allowAction = (element) ->
  # The message is something like "Are you sure?"
  message = element.data('confirm')
  # If there's no message, there's no data-confirm attribute, 
  # which means there's nothing to confirm
  return true unless message
  # Clone the clicked element (probably a delete link) so we can use it in the dialog box.
  $link = element.clone()
    # We don't necessarily want the same styling as the original link/button.
    .removeAttr('class')
    # We don't want to pop up another confirmation (recursion)
    .removeAttr('data-confirm')
    # We want a button
    .addClass('btn').addClass('btn-primary')
    # We want it to sound confirmy
    .html("Continue")

  # Create the modal box with the message
  modal_html = """
               <div id="confirm_modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="confirm_modal" aria-hidden="true">
                  <div class="modal-dialog">
                    <div class="modal-content">                
                      <div class="modal-header">
                     <a class="close" data-dismiss="modal">×</a>
                     <h4>#{message}</h4>
                   </div>
                   <div class="modal-footer">
                     <button class="btn btn-default" data-dismiss="modal" aria-hidden="true">Cancel</button>
                   </div>
                 </div>
                </div>
               </div>
               """
  $modal_html = $(modal_html)
  # Add the new button to the modal box
  $modal_html.find('.modal-footer').append($link)
  # Pop it up
  $modal_html.modal()
  # Prevent the original link from working
  return false