/*
* Solves a riddle from "logic.puzzlebaron.com" based around several Hawaiian islands.
* 
* Finn Frankis
* April 2, 2019
*/

(clear)
(reset)

(batch util/utilities.clp)

/*
* Represents a piece of information as given in the problem. The type, for this problem, is either culture or name.
* The year in which the island was discovered will be used to identify the islands.
*/
(deftemplate info (slot type) (slot value) (slot year))

(defrule startup "Starts up the game and introduces the user to the problem."
    =>
    (printline "This game solves the problem with the following information given:
                1. Zafet was discovered 14 years after the island on which the Hakili people lived.
                2. Jujihm was inhabited by the Kukani.
                3. Teuz was either the island on which the Hakili people lived or the island discovered in 1768.
                4. Fushil was discovered in 1761.
                5. Of the island on which the Iakepa people lived and Jujihm, one was discovered in 1775 and the other was discovered in 1768.
                6. Nuhirk wasn't inhabited by the Holo'oka.
                When was the island where the Wainani people live discovered?")
    /*
    * Asserts all possible values for island name, culture, and discovery year.
    */
    (assert (value name Fushil))
    (assert (value name Jujihm))
    (assert (value name Nuhirk))
    (assert (value name Teuz))
    (assert (value name Zafet))

    (assert (value culture Hakili))
    (assert (value culture Holo'oka))
    (assert (value culture Iakepa))
    (assert (value culture Kukani))
    (assert (value culture Wainani))

    (assert (value year 1754))
    (assert (value year 1761))
    (assert (value year 1768))
    (assert (value year 1775))
    (assert (value year 1782))
)

(defrule solution "Finds the solution to the riddle and asserts it into the factbase."
    /*
    * Pattern-Matching Variable Definitions:
    * 
    * ?c1 - the Hakili people's island discovery year
    * ?c2 - the Kukani people's island discovery year
    * ?c3 - the Iakepa people's island discovery year
    * ?c4 - the Holo'oka people's island discovery year
    * ?c5 - the Wainani people's island discovery year
    *
    * ?n1 - Zafet island's discovery year
    * ?n2 - Jujihm island's discovery year
    * ?n3 - Teuz island's discovery year
    * ?n4 - Fushil island's discovery year
    * ?n5 - Nuhirk island's discovery year
    */

    /* 
    * Zafet (discovered in year ?n1) was discovered 14 years after that of the Hakili (living on the island discovered in year ?c1). 
    */
    (info (type culture) (value Hakili) (year ?c1))
    (info (type name) (value Zafet) (year ?n1 &:(= ?n1 (+ ?c1 14))))

    /* 
    * Jujihm (discovered in year ?n2) had the same discovery year (same island) as that 
    * inhabited by the Kukani (living on the island discovered in year ?c2).
    * Jujihm was either discovered in 1775 or 1768 (fact 5).
    */
    (info (type name) (value Jujihm) (year ?n2 &~?n1 &:(or (= ?n2 1775) (= ?n2 1778))))
    (info (type culture) (value Kukani) (year ?c2 & ?n2 &~?c1))

    /* 
    * Teuz (discovered in year ?n3) was either the island on which the Hakili people lived (?c1) or discovered in 1768.
    */ 
    (info (type name) (value Teuz) (year ?n3 &:(or (= ?n3 ?c1) (= ?n3 1768)) &~?n2 &~?n1))

    /* 
    * Fushil (discovered in year ?n4) was discovered in 1761.
    */ 
    (info (type name) (value Fushil) (year ?n4 & 1761 &~?n3 &~?n2 &~?n1))

    /* 
    * The Iakepa people (living on the island discovered in year ?c3) live on the island discovered 
    * in either 1775 or 1768, but not the one on which the Jujihm live (?n2).
    */
    (info (type culture) (value Iakepa) (year ?c3 &:(or (= ?c3 1775) (= ?c3 1768)) &~?n2 &~?c2 &~?c1))

    /* 
    * Nuhirk (discovered in year ?n5) was not inhabited by the Holo'oka (living on the island discovered in year ?c4).
    */
    (info (type name) (value Nuhirk) (year ?n5 &~?n4 &~?n3 &~?n2 &~?n1))
    (info (type culture) (value Holo'oka) (year ?c4 &~?n5 &~?c3 &~?c2 &~?c1))

    /* 
    * The Wainani people (living on the island discovered in year ?c5) live on some unknown island.
    */
    (info (type culture) (value Wainani) (year ?c5 &~?c4 &~?c3 &~?c2 &~?c1))
    =>
    (assert (solution culture Hakili ?c1))
    (assert (solution culture Kukani ?c2))
    (assert (solution culture Iakepa ?c3))
    (assert (solution culture Holo'oka ?c4))
    (assert (solution culture Wainani ?c5))

    (assert (solution name Zafet ?n1))
    (assert (solution name Jujihm ?n2))
    (assert (solution name Teuz ?n3))
    (assert (solution name Fushil ?n4))
    (assert (solution name Nuhirk ?n5))
)

(defrule print-solution "Prints the solution after it has been asserted."
    (solution culture ?c1 1754)
    (solution culture ?c2 1761)
    (solution culture ?c3 1768)
    (solution culture ?c4 1775)
    (solution culture ?c5 1782)

    (solution name ?n1 1754)
    (solution name ?n2 1761)
    (solution name ?n3 1768)
    (solution name ?n4 1775)
    (solution name ?n5 1782)
    => 
    (printline "Year | Name | Culture")
    (printline (str-cat "1754 | " ?n1 " | " ?c1))
    (printline (str-cat "1761 | " ?n2 " | " ?c2))
    (printline (str-cat "1768 | " ?n3 " | " ?c3))
    (printline (str-cat "1775 | " ?n4 " | " ?c4))
    (printline (str-cat "1782 | " ?n5 " | " ?c5))    
)

(defrule generateCombinations "Given a possible value, asserts that value paired with a given age."
   ?fact <- (value ?type &:(not (= ?type "year")) ?value)
   ?year <- (value year ?yearVal)
   =>
   (assert (info (type ?type) (value ?value) (year ?yearVal)))
)

(run)
(return)

; (batch LogicPuzzles/fijianislands.clp)