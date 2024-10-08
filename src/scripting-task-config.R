# Load the hubAdmin package
library(hubAdmin)

# Create a representation of a task ID item as a list object of `class task_id`, the `origin_date_id`
origin_date_id <- create_task_id("origin_date", 
                                 required = NULL, 
                                 optional = c("2023-01-02", "2023-01-09", "2023-01-16"))

# Create a representation of a task ID item as a list object of `class task_id`, the `location_id`
location_id <- create_task_id("location",
                              required = "US",
                              optional = c("01", "02", "04", "05", "06"))

# Create a representation of a task ID item as a list object of `class task_id`, the `horizon_id`
horizon_id <- create_task_id("horizon", required = 1L, optional = 2:4)

# Create a representation of a task ID item as a list object of `class task_id`, the `target_id`
target_id <- create_task_id("target", required = "inc hosp", optional = "inc death")

# Combine the `task_id` objects to create a `task_ids` class object, the `task_ids_example`
task_ids_example <- create_task_ids(origin_date_id, location_id, horizon_id, target_id)

# Create a representation of a `mean` output type as a list object of class `output_type_item`
mean_example <- create_output_type_mean(is_required = TRUE, 
                                        value_type = "double", 
                                        value_minimum = 0L)

# Create a representation of a `median` output type as a list object of class `output_type_item`
median_example <- create_output_type_median(is_required = FALSE, 
                                            value_type = "integer")

# Create a representation of a `quantile` output type as a list object of class `output_type_item`
quantile_example <- create_output_type_quantile(required = c(0.25, 0.5, 0.75), 
                                                optional = c(0.1, 0.2, 0.3, 0.4, 0.6, 0.7, 0.8, 0.9), 
                                                value_type = "double", 
                                                value_minimum = 0)

# Combine the point estimate `output_type_item` objects to create an `output_type` class object, the `output_type_example1`
output_type_example1 <-  create_output_type(mean_example, median_example)

# Combine the other `output_type_item` objects to create an `output_type` class object, the `output_type_example2`
output_type_example2 <- create_output_type(mean_example, quantile_example)

# Create a representation of a `target_metadata` item as a list object of class `target_metadata_item`, the `target_metadata_item1` that will hold the metadata for the target of incident influenza hospitalizations
target_metadata_item1 <- create_target_metadata_item(target_id = "inc hosp", 
                                                     target_name = "Weekly incident influenza hospitalizations", 
                                                     target_units = "rate per 100,000 population", 
                                                     target_keys = list(target = "inc hosp"), 
                                                     target_type = "discrete", 
                                                     is_step_ahead = TRUE, 
                                                     time_unit = "week")

# Create a representation of a `target_metadata` item as a list object of class `target_metadata_item`, the `target_metadata_item2`, that will hold the metadata for the target of incident influenza deaths
target_metadata_item2 <- create_target_metadata_item(target_id = "inc death", 
                                                     target_name = "Weekly incident influenza deaths", 
                                                     target_units = "rate per 100,000 population", 
                                                     target_keys = list(target = "inc death"), 
                                                     target_type = "discrete", 
                                                     is_step_ahead = TRUE, 
                                                     time_unit = "week")

# Combine the `target_metadata_item` objects to create a `target_metadata` class object, the `target_metadata_example`
target_metadata_example <- create_target_metadata(target_metadata_item1, target_metadata_item2)

#Create an object of class `model_task` representing a model task, the `model_task_item1`
model_task_item1 <- create_model_task(task_ids = task_ids_example, 
                                      output_type = output_type_example1, 
                                      target_metadata = target_metadata_example)

#Create another object of class `model_task` representing a similar model task, the `model_task_item2`
model_task_item2 <- create_model_task(task_ids = task_ids_example, 
                                      output_type = output_type_example2, 
                                      target_metadata = target_metadata_example)

# Combine the `model_task` objects to create a `model_tasks` class object, the `model_task_example`
model_task_example <- create_model_tasks(model_task_item1, model_task_item2)

# Create a representation of a round as a list object of class `round`, the `round1`
round1 <- create_round(
  round_id_from_variable = TRUE,
  round_id = "origin_date",
  round_name = "Round 1",
  model_tasks = model_task_example,
  submissions_due = list(
    relative_to = "origin_date",
    start = -4L,
    end = 2L
  )
)

# Create a different representation of a round as a list object of class `round`, the `round2`
round2 <- create_round(
  round_id_from_variable = TRUE,
  round_id = "origin_date",
  round_name = "Round 2",
  model_tasks = model_task_example,
  submissions_due = list(start = "2023-01-09", end = "2023-01-16")
)

# Combine the `round` objects to create a `rounds` class object, the `rounds`
rounds <- create_rounds(round1, round2)

# Create a representation of a complete `"tasks"` config file as a list object of class `config`
config <- create_config(rounds)

# Write the `config` object to a JSON file (note that this will overwrite any existing file with the same name in the "hub-config" folder)
write_config(config, hub_path = ".", overwrite = TRUE)

# json_output <- jsonlite::toJSON(config, pretty = TRUE, auto_unbox = TRUE)
# write(json_output, "hub-config/tasks.json")
