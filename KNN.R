# Load the caret package for KNN regression
library(caret)

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

# Train the KNN Regression model using all features
knn_model <- train(FinalGrades ~ ., data = train_data, method = "knn", trControl = trainControl(method = "cv"))

# Make predictions on the test set
predictions_knn <- predict(knn_model, newdata = test_data)

# Compute Mean Squared Error (MSE)
mse_knn <- mean((test_data$FinalGrades - predictions_knn)^2)

# Print the Mean Squared Error (MSE)
cat("Mean Squared Error (KNN):", mse_knn, "\n")

# KNN does not inherently provide prediction intervals
