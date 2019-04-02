/*
* Solves a riddle from "brainzilla.com" based around several kids and their instruments.
* 
* Finn Frankis
* April 2, 2019
*/

(clear)
(reset)

(batch util/utilities.clp)

/*
* Represents a piece of information as given in the problem. The type, for this problem, is either instrument or name.
* The age will be used to identify the four girls.
*/
(deftemplate info (slot type) (slot value) (slot age))

(defrule startup "Starts up the game and introduces the user to the problem."
   =>
   (printline "This game solves the problem with the following information given:
               1. Ariella is learning about the accordion.
               2. The kid learning about the xylophone is 2 years younger than Valeria.
               3. Kallie is either 6 or 8 years old.
               4. The 7-year old girl is learning about the oboe.
               How old is Stella? How old is the ukulele player?")
   /*
   * Asserts all possible options for the two fact types: instrument and name.
   */
   (assert (value instrument accordion))
   (assert (value instrument xylophone))
   (assert (value instrument oboe))
   (assert (value instrument ukulele))
   (assert (value name Ariella))
   (assert (value name Kallie))
   (assert (value name Valeria))
   (assert (value name Stella))
)

(defrule solution "Finds the solution to the riddle and asserts it into the factbase."
   /*
   * Pattern-Matching Variable Definitions:
   * 
   * ?i1 - the accordion-player's age
   * ?i2 - the xylophone-player's age
   * ?i3 - the oboe-player's age
   * ?i4 - the ukulele-player's age
   *
   * ?n1 - Ariella's age
   * ?n2 - Valeria's age
   * ?n3 - Kallie's age
   * ?n4 - Stella's age
   */

   ; The accordion-player (aged ?i1) is the same age as Ariella (aged ?n1).
   (info (type instrument) (value accordion) (age ?i1))
   (info (type name) (value Ariella) (age ?n1 &?i1))
   
   ; The xylophone-player (aged ?i2) is 2 years younger than Valeria (aged ?n2).
   (info (type name) (value Valeria) (age ?n2 &~?n1))
   (info (type instrument) (value xylophone) (age ?i2 &~?i1 &:(= ?i2 (- ?n2 2))))

   ; Kallie (aged ?n3) is either 6 or 8 years old.
   (info (type name) (value Kallie) (age ?n3 &~?n2 &~?n1 &:(or (= ?n3 6) (= ?n3 8))))

   ; The oboe-player (aged ?i3) is 7 years old.
   (info (type instrument) (value oboe) (age ?i3 &~?i2 &~?i1 &:(= ?i3 7)))

   ; The ukulele player (aged ?i4) and Stella (aged ?n4) have some unknown age.
   (info (type instrument) (value ukulele) (age ?i4 &~?i3 &~?i2 &~?i1))
   (info (type name) (value Stella) (age ?n4 &~?n3 &~?n2 &~?n1))

   =>

   (assert (solution instrument accordion ?i1))
   (assert (solution instrument xylophone ?i2))
   (assert (solution instrument oboe ?i3))
   (assert (solution instrument ukulele ?i4))

   (assert (solution name Ariella ?n1))
   (assert (solution name Valeria ?n2))
   (assert (solution name Kallie ?n3))
   (assert (solution name Stella ?n4))
)

(defrule printSolution "Prints the solution after it has been asserted."
   (solution instrument ?i1 6)
   (solution instrument ?i2 7)
   (solution instrument ?i3 8)
   (solution instrument ?i4 9)
   (solution name ?n1 6)
   (solution name ?n2 7)
   (solution name ?n3 8)
   (solution name ?n4 9)
   => 
   (printline "Age | Name | Instrument")
   (printline (str-cat "6 | " ?n1 " | " ?i1))
   (printline (str-cat "7 | " ?n2 " | " ?i2))
   (printline (str-cat "8 | " ?n3 " | " ?i3))    
   (printline (str-cat "9 | " ?n4 " | " ?i4))    
)

(defrule generateCombinations "Given a possible value, generates all possible combinations for that value (one with each possible age)."
   ?fact <- (value ?type ?value)
   =>
   (retract ?fact)
   (assert (info (type ?type) (value ?value) (age 6)))
   (assert (info (type ?type) (value ?value) (age 7)))
   (assert (info (type ?type) (value ?value) (age 8)))
   (assert (info (type ?type) (value ?value) (age 9)))
)

(run)
(return)