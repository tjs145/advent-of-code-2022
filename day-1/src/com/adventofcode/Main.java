package com.adventofcode;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class Main {

    private static List<Integer> elfCalories = new ArrayList<>();

    public static void main(String[] args) throws FileNotFoundException {
	    Scanner scanner = new Scanner(new BufferedInputStream(new FileInputStream("./input.txt")));
        int calories = 0;

        while (scanner.hasNextLine()) {
            String line = scanner.nextLine();

            if (line.isEmpty()) {
                elfCalories.add(calories);
                calories = 0;
            } else {
                calories += Integer.parseInt(line);
            }
        }

        if (calories != 0) {
            elfCalories.add(calories);
        }

        int totalTopCalories = 0;
        for (int i = 0; i < 3; i++) {
            Integer topCalories;
            topCalories = elfCalories.stream().max(Integer::compareTo).orElseThrow();
            System.out.println(topCalories);
            elfCalories.remove(topCalories);
            totalTopCalories += topCalories;
        }
        System.out.println(totalTopCalories);
    }
}
