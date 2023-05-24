// Import the necessary libraries
import processing.data.*;

// Declare global variables
float redX, redY, blueX, blueY; // Coordinates of the circles
float radius; // Radius of the circles
float distance; // Distance between the centers of the circles
boolean insideRed = false; // Flag to indicate if the cursor is inside the red circle
boolean insideBlue = false; // Flag to indicate if the cursor is inside the blue circle
int startTime, endTime; // Time variables to measure the duration
String csvResult; // String to store the CSV result

void setup() {
  size(800, 600); // Set the size of the window
  noStroke(); // Remove the stroke from the circles
  generateCircles(); // Generate random circles
  csvResult = "Radius,Distance,Time\n"; // Initialize the CSV result with headers
}

void draw() {
  background(255); // Set the background color to white
  fill(255, 0, 0); // Set the fill color to red
  ellipse(redX, redY, radius * 2, radius * 2); // Draw the red circle
  fill(0, 0, 255); // Set the fill color to blue
  ellipse(blueX, blueY, radius * 2, radius * 2); // Draw the blue circle

  checkCursor(); // Check if the cursor is inside any circle

  if (insideRed && insideBlue) { // If both flags are true, the task is finished
    endTime = millis(); // Record the end time
    printResults(); // Print the results in CSV format
    noLoop(); // Stop the draw loop
  }
}

// A function to generate random circles
void generateCircles() {
  radius = random(5, 35); // Generate a random radius for both circles between 20 and 100 pixels

  redX = random(radius, width - radius); // Generate a random x-coordinate for the red circle within the window bounds
  redY = random(radius, height - radius); // Generate a random y-coordinate for the red circle within the window bounds

  do { // Repeat until the circles do not overlap
    blueX = random(radius, width - radius); // Generate a random x-coordinate for the blue circle within the window bounds
    blueY = random(radius, height - radius); // Generate a random y-coordinate for the blue circle within the window bounds

    distance = dist(redX, redY, blueX, blueY); // Calculate the distance between the centers of the circles

  } while (distance < radius * 2); // Check if the circles overlap

}

// A function to check if the cursor is inside any circle
void checkCursor() {
  float d1 = dist(mouseX, mouseY, redX, redY); // Calculate the distance from the cursor to the center of the red circle
  float d2 = dist(mouseX, mouseY, blueX, blueY); // Calculate the distance from the cursor to the center of the blue circle

  if (d1 < radius) { // If the distance is less than the radius of the red circle
    insideRed = true; // Set the flag to true
    if (!insideBlue) { // If this is the first time entering a circle
      startTime = millis(); // Record the start time
    }
  }

  if (d2 < radius) { // If the distance is less than the radius of the blue circle
    insideBlue = true; // Set the flag to true
    if (!insideRed) { // If this is not a valid sequence (blue before red)
      insideBlue = false; // Reset the flag to false
      generateCircles(); // Generate new circles
    }
  }
}

// A function to print the results in CSV format
void printResults() {
  String result = int(radius) + "," + distance + "," + (endTime - startTime) + "\n"; // Create a CSV row
  csvResult += result; // Append the row to the CSV result

  println(csvResult); // Print the CSV result
}
