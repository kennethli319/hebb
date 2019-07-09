// Import library
// TODO: NEED TO INSTALL
import java.io.*; 
import java.util.*; 

import processing.sound.*;
import java.util.Random; 
import java.util.ArrayList;
import java.util.Collections;

// Public Variables
float rectX, rectY;      // Position of square button
float circleX, circleY;  // Position of circle button
// TODO: Change the size accordingly 
int rectSize = 120 ;     // Diameter of rect
int circleSize = rectSize;   // Diameter of circle

int option = 0;
int number = 3;
int click_num = 0;
int data_total = 0;

String[] wav_data = new String[71];
String[] pic_data = new String[71];
String[] word_data = new String[71];

int[] ans = new int[number];
int[] tar_ans = new int[number];
int[] show_list = new int[number];
int[] repeat_list = new int[number];
float[] r_time = new float[number];
int[] clicked_list = new int[number];
int i = 0;
float accuracy = 0.0;
int wrong_time = 0;
int starting_num = 0;
int stage_num = 1;
int trial_num = 1;

color rectColor, circleColor, baseColor;
color rectHighlight, circleHighlight;
color currentColor;

boolean rectOver = false;
boolean circleOver = false;
boolean reset_level = true;

int mil;
int p_mil = 0;

//PFont f;
Table table;
PImage img;
SoundFile file;
    
PrintWriter output;  

String filename = "test";
    
ArrayList<Integer> myNumbers = new ArrayList<Integer>();

void select_ran(int num) {
    int size = data_total-1;

    ArrayList<Integer> list = new ArrayList<Integer>(size);
    for(int i = 1; i <= size; i++) {
        list.add(i);
    }

    Random rand = new Random();

    if (stage_num == 2 && myNumbers.contains(trial_num)) {
      
      tar_ans = repeat_list; 
    
    } else {
      
      int p = 0;
      
      while(p < num) {
          int index = rand.nextInt(list.size());
          tar_ans[p] = list.remove(index);
          p+=1;
      }
      
    }
    
    if (stage_num == 2 && trial_num == 1){
       repeat_list = tar_ans;
    }
    
    show_list = tar_ans.clone();
    shuffleArray(show_list);
        
}

private static void shuffleArray(int[] array)
{
    int index, temp;
    Random random = new Random();
    for (int i = array.length - 1; i > 0; i--)
    {
        index = random.nextInt(i + 1);
        temp = array[index];
        array[index] = array[i];
        array[i] = temp;
    }
}

void setup() {
  
  output = createWriter(filename + "_log.txt");
  
  //fullScreen();
  size(1200,400);
  background(255);
  rectColor = color(0);
  rectHighlight = color(51);
  circleColor = color(255);
  circleHighlight = color(204);
  baseColor = color(102);
  currentColor = baseColor;
  //f = createFont("Arial",16); // Arial, 16 point
  ellipseMode(CENTER);
  
  myNumbers.add(4);
  myNumbers.add(7);
  myNumbers.add(10);
  myNumbers.add(13);
  
  circleX = width/2-rectSize/2-float(number)/2.0*(rectSize/5+rectSize);
  circleY = height/5*4-rectSize/2;
  
  fill(100);
  for (int i = 0; i< number; i++){
    rect(circleX, circleY, circleSize, circleSize);    
    circleX += (20+circleSize);
  }
  
  rectX = width/2-rectSize/2-float(number)/2.0*(rectSize/5+rectSize);
  rectY = height/5-rectSize/2;
  
  fill(200);
  for (int i = 0; i< number; i++){
    rect(rectX, rectY, rectSize, rectSize);
    rectX += (20+rectSize);
  }
  
  println("--------- Stage 0: Reading data ---------");
  output.println("--------- Stage 0: Reading data ---------");
  
  table = loadTable("datapath.csv", "header");

  println(table.getRowCount() + " total rows in table");
  output.println(table.getRowCount() + " total rows in table");
  
  data_total = table.getRowCount();
  
  int idx = 0;

  for (TableRow row : table.rows()) {
    
    String wav = row.getString("wav");
    String pic = row.getString("pic");
    String word = row.getString("word");
  
    wav_data[idx] = wav;
    pic_data[idx] = pic;
    word_data[idx] = word;
    
    //println(word + "(" + idx + "): " + wav + " " + pic);
    //output.println(word + "(" + idx + "): " + wav + " " + pic);
    
    idx += 1;
  }
  
  System.out.println("--------- Stage 1: Start word span test ---------");
  output.println("--------- Stage 1: Start word span test ---------");
  
  select_ran(number);
  
  play_audio();
}

void draw() {
  mil = millis();
  update(mouseX, mouseY);  
  play_audio();
}

void play_audio(){
    if (reset_level){
      
      for (int n =0; n< number; n++){
        file = new SoundFile(this, wav_data[tar_ans[n]]);
        file.amp(1.0);
        file.play();
        
        delay(1000);
      }
      mil = millis();
      p_mil = mil;
      reset_level = false;
    }
}

void keyPressed() {
  if (ans[number-1] != 0 && key == ' ') {
   restart_level();
  } 
}

void restart_level(){ 
  if (ans[number-1] != 0){
    
    // Print level infomation
    
    System.out.println("level: " + number);
    output.println("level: " + number);
    
    System.out.println("trial_num: " + trial_num);
    output.println("trial_num: " + trial_num);
        
    accuracy = 0.0;
    
    for (int m = 0; m < ans.length; m++){
       if (tar_ans[m] == show_list[ans[m]-1]){
         accuracy += 1.0 / float(ans.length) * 100.0;
      }
    }
        
    System.out.println("accuracy: " + accuracy);
    output.println("accuracy: " + accuracy);
    
    System.out.print("tar_ans:\t");
    output.print("tar_ans:\t");
    for (int k =0; k< number; k++){
       System.out.print(word_data[tar_ans[k]] + " ");
       output.print(word_data[tar_ans[k]] + " ");
    }
    
    System.out.println();
    output.println();
    
    System.out.print("show_list:\t");
    output.print("show_list:\t");
    for (int k =0; k< number; k++){
       System.out.print(word_data[show_list[k]] + " ");
       output.print(word_data[show_list[k]] + " ");
    }
    
    System.out.println();
    output.println();
    
    System.out.print("ans:\t");
    output.print("ans:\t");
    for (int k =0; k< number; k++){
       System.out.print(word_data[show_list[ans[k]-1]] + " ");
       output.print(word_data[show_list[ans[k]-1]] + " ");
    }
    System.out.println();
    output.println();

    System.out.print("r_time(in ms): ");
    output.print("r_time(in ms): ");
    for (int k =0; k< number; k++){
       System.out.print(r_time[k] + " ");
       output.print(r_time[k] + " ");
    }
    
    System.out.println("\n");
    output.println("\n");
    
    trial_num +=1;
    
    output.flush(); // Writes the remaining data to the file
    
    // TODO: Change to 13 for real test
    if (stage_num == 2 && trial_num > 13){
      System.out.println("--------- Stage 2: Stop Hebb repetition learning task ---------");
      output.println("--------- Stage 2: Stop Hebb repetition learning task ---------");
      stage_num = 3;
      output.flush(); // Writes the remaining data to the file
      output.close(); // Finishes the file
      delay(1000);
      exit();
    }

    // ONLY stage 1: Decide next level or same level
    
    if (stage_num == 1){    
        if (accuracy >= 100.0){  
          number +=1;
          wrong_time = 0;
        } else {
          wrong_time += 1;
        }
        
        if (wrong_time > 1){
          System.out.println("--------- Stage 1: Stop word span test ---------");
          System.out.println("wrong_time: " + wrong_time);
          System.out.println("current number: " + number);
    
          output.println("--------- Stage 1: Stop word span test ---------");
          output.println("wrong_time: " + wrong_time);
          output.println("current number: " + number);
          
          starting_num = (number+1);
          System.out.println("starting number: " + starting_num );
          System.out.println();
          output.println("starting number: " + starting_num );
          output.println();      
          
          System.out.println("--------- Stage 2: Start Hebb repetition learning task ---------");
          output.println("--------- Stage 2: Start Hebb repetition learning task ---------");
          
          stage_num = 2;
          trial_num = 1;
          number = starting_num;
          
        }
    }
    
    ans = new int[number];
    tar_ans = new int[number];
    r_time = new float[number];
    clicked_list = new int[number];
    click_num = 0;
    i = 0;
    reset_level = true;
    select_ran(number);

    background(255);
    
  }
}

public static boolean contains(final int[] array, final int v) {

        boolean result = false;

        for(int i : array){
            if(i == v){
                result = true;
                break;
            }
        }

        return result;
    }

void update(int x, int y) {
  option = 0;
  circleX = width/2-rectSize/2-float(number)/2.0*(rectSize/5+rectSize);
  rectX = width/2-rectSize/2-float(number)/2.0*(rectSize/5+rectSize);
  
  for (int i = 0; i< number; i ++){
    
    img = loadImage(pic_data[show_list[i]]);
    
    if (contains(ans, i+1) == false){
        
      if ( overRect(circleX, circleY, circleSize, circleSize) ) {
        circleOver = true;
        rectOver = false;
        option = i+1;
        fill(circleHighlight);
        rect(circleX, circleY, circleSize, circleSize);
        image(img, circleX+5, circleY+5, circleSize-10, circleSize-10);
      } else {
        circleOver = rectOver = false;
        fill(circleColor);
        rect(circleX, circleY, circleSize, circleSize);
        image(img, circleX+5, circleY+5, circleSize-10, circleSize-10);
      }
    } else{
      fill(50);
      rect(circleX, circleY, circleSize, circleSize);
      image(img, circleX+5, circleY+5, circleSize-10, circleSize-10);
    }
    fill(200);
    rect(rectX, rectY, rectSize, rectSize);
    
      if (ans[i] != 0){
        img = loadImage(pic_data[show_list[ans[i]-1]]);
        image(img, rectX+5, rectY+5, circleSize-10, circleSize-10);
    }
    
    circleX += (20+circleSize);
    rectX += (20+rectSize);
  }
}

boolean clicked;

void mousePressed() {
 
  clicked = false;
  
  for (int j =0; j<clicked_list.length; j++){
    if (option == clicked_list[j]){
      clicked = true;
    }
  }
  
  if (option != 0 && clicked == false){
    ans[click_num] = option;
    r_time[click_num] = mil-p_mil;
    p_mil = mil;
    clicked_list[i] = option;
    
    //textFont(f,16);                  
    //fill(0);                          
    //text(str(tar_ans[option-1]),(width/2-rectSize/2-float(number)/2.0*(rectSize/5+rectSize))+(20+rectSize)*(click_num)+rectSize/2,rectY-rectSize/2);   // STEP 5 Display Text
    
    click_num += 1;
    i += 1;
    
  }
}

boolean overRect(float x, float y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

boolean overCircle(float x, float y, int diameter) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true;
  } else {
    return false;
  }
}
