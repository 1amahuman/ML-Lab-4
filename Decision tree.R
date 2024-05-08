# Load the rpart package for decision tree regression
library(rpart)

# Set a fixed random seed for reproducibility
set.seed(10923)

# Number of students
num_students <- 500

# Simulate study hours (ranging from 1 to 20 hours)
study_hours <- sample(1:20, num_students, replace = TRUE)

# Simulate quiz scores (ranging from 0 to 100)
quiz_scores <- sample(0:100, num_students, replace = TRUE)

# Simulate forum participation (ranging from 0 to 50 posts)
forum_posts <- sample(0:50, num_students, replace = TRUE)

# Simulate previous grades (ranging from 0 to 100)
previous_grades <- sample(0:100, num_students, replace = TRUE)

# Simulate final grades (ranging from 0 to 100)
final_grades <- 0.3 * study_hours + 0.4 * quiz_scores + 0.2 * forum_posts + 0.1 * previous_grades + rnorm(num_students, mean = 0, sd = 5) + 25

# Create a data frame
student_data <- data.frame(StudyHours = study_hours, QuizScores = quiz_scores, ForumPosts = forum_posts, PreviousGrades = previous_grades, FinalGrades = final_grades)

# Splitting the data into training and testing sets (80% training, 20% testing)
set.seed(10923) # Set seed for reproducibility
sample_index <- sample(1:nrow(student_data), 0.8 * nrow(student_data))
train_data <- student_data[sample_index, ]
test_data <- student_data[-sample_index, ]

# Train the Decision Tree Regression model using all features
decision_tree_model <- rpart(FinalGrades ~ ., data = train_data, method = "anova")

# Make predictions on the test set
predictions_decision_tree <- predict(decision_tree_model, newdata = test_data)

# Compute Mean Squared Error (MSE)
mse_decision_tree <- mean((test_data$FinalGrades - predictions_decision_tree)^2)

# Print the Mean Squared Error (MSE)
cat("Mean Squared Error (Decision Tree):", mse_decision_tree, "\n")

# Number of bootstrap samples
num_bootstraps <- 1000

# Initialize an empty matrix to store predictions
predictions_decision_tree_boot <- matrix(NA, nrow = nrow(test_data), ncol = num_bootstraps)

# Iterate through each bootstrap sample
for (i in 1:num_bootstraps) {
  # Sample with replacement from the test data
  boot_sample <- test_data[sample(1:nrow(test_data), replace = TRUE), ]
  
  # Make predictions on the bootstrapped sample
  predictions_decision_tree_boot[, i] <- predict(decision_tree_model, newdata = boot_sample)
}

# Compute lower and upper bounds for the prediction intervals
lower_bound <- apply(predictions_decision_tree_boot, 1, quantile, probs = 0.025)
upper_bound <- apply(predictions_decision_tree_boot, 1, quantile, probs = 0.975)

# Calculate accuracy using prediction intervals
correct_predictions_interval <- test_data$FinalGrades >= lower_bound & test_data$FinalGrades <= upper_bound
accuracy_interval <- sum(correct_predictions_interval) / length(correct_predictions_interval)

# Print accuracy using prediction intervals
cat("Model Accuracy using Prediction Interval (Decision Tree):", round(accuracy_interval * 100, 2), "%\n")
