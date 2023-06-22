#' Title
#'
#' @param marginal_effects_list
#'
#' @return
#' @export
#'
#' @examples

do_table_marginal_effects <- function(
    combined_results,
    combined_results_girls,
    combined_results_boys
) {
  # Create a flextable object for the combined results
  table <- flextable::flextable(combined_results)
  table_girls <- flextable::flextable(combined_results_girls)
  table_boys <- flextable::flextable(combined_results_boys)
  
  # Format table appearance
  table <- flextable::theme_apa(table)
  table <- flextable::line_spacing(table, space = 1, part = "all")
  table <- flextable::set_table_properties(table, layout = "autofit")
  table <- flextable::fontsize(table, size = 10)
  
  table_girls <- flextable::theme_apa(table_girls)
  table_girls <- flextable::line_spacing(table_girls, space = 1, part = "all")
  table_girls <- flextable::set_table_properties(table_girls, layout = "autofit")
  table_girls <- flextable::fontsize(table_girls, size = 10)
  
  table_boys <- flextable::theme_apa(table_boys)
  table_boys <- flextable::line_spacing(table_boys, space = 1, part = "all")
  table_boys <- flextable::set_table_properties(table_boys, layout = "autofit")
  table_boys <- flextable::fontsize(table_boys, size = 10)

  # Create a Word document and add the tables
  doc <- officer::read_docx()
  doc <- flextable::body_add_flextable(doc, table)
  doc <- flextable::body_add_flextable(doc, table_girls)
  doc <- flextable::body_add_flextable(doc, table_boys)
  
  # Save the table to a Word file
  file_name <- file.path(config$outdir_lso, config$outdat_marg)
  print(doc, target = file_name)
  
}
