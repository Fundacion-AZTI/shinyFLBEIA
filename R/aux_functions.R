# -------------------------------------------------------------------------
# Aux functions:

# Rescale for radar plot:
my_scale_fun = function(x) {
  # Rescale with min == 0
  x_scaled <- (x - 0) / (max(x) - 0) 
  # If all are zero
  if(all(is.nan(x_scaled))) x_scaled = rep(1, times = length(x))
  return(x_scaled)
}

# Make colored icons next to MPS:
list_content <- function(col, content) {
  paste0('<div style="display:inline-block"><i class="fa fa-circle"
                                           style="color:', col, 
         ';margin-top:3px;"></i><div style="display:inline-block;color:white;padding-left:5px;">', 
         content, 
         '</div></div>')
  
}