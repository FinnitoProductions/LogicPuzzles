/*
* Solves a riddle from "logic.puzzlebaron.com" based around information about several candidates and their speeches.
* 
* Finn Frankis
* April 2, 2019
*/

/*
* Represents a piece of information as given in the problem. The type, for this problem, is candidate, party, date, and year.
* The speakers will be each assigned a number to differentiate them.
*/
(deftemplate info (slot type) (slot value) (slot number))

(defrule startup "Starts up the game and introduces the user to the problem."
    =>
    (printline "This game solves the problem with the following information given:
                1. The person whose speech brought in 2,600 attendees spoke sometime before the Libertarian.
                2. Gara Oldman didn't speak on January 15th.
                3. Conner Dawes spoke in front of 1,200 attendees.
                4. Of the speaker whose speech brought in 1,200 attendees and Daniel Stead, one was the Republican and the other spoke on January 17th.
                5. Fred Maddox wasn't the Democrat.
                6. Conner Dawes was the Libertarian.
                7. Gara Oldman didn't speak on January 18th.
                8. Barron Tweed was the Reformist.
                9. Daniel Stead was either the candidate whose speech brought in 850 attendees or the candidate who spoke on January 20th.
                10. Ashley Dale spoke 1 day before the candidate whose speech brought in 1,875 attendees.
                11. Barron Tweed was either the Objectivist or the candidate whose speech brought in 1,450 attendees.
                12. The politician who spoke on January 14th was either Gara Oldman or the Socialist.
                13. The Independent spoke 1 day before the speaker whose speech brought in 2,600 attendees.
                14. The Objectivist spoke 1 day after the person whose speech brought in 1,875 attendees.
                15. The speaker who spoke on January 20th didn't speak in front of exactly 2,250 attendees.
                ")
)

(defrule solution "Finds the solution to the riddle and asserts it into the factbase."
    /*
    * ?p1 - the speaker number of the Libertarian 
    * 
    * ?a1 - the speaker number of the person with 2,600 attendees
    *
    * ?d1 - the speaker number of the person who spoke on ?D1
    * ?d2 - the speaker number of the person who spoke on ?D2
    * 
    * ?n1 - the speaker number of Gara Oldman
    * 
    * ?D1 - the date on which the Libertarian spoke
    * ?D2 - the date on which the person with 2,600 attendees spoke
    * ?D3 - the date on which Gara Oldman spoke
    */

    (info (type party) (value Libertarian) (number ?p1))
    (info (type attendees) (value 2600) (number ?a1))
    (info (type date) (value ?D1) (number ?d1 & ?p1))
    (info (type date) (value ?D2 &:(< ?D2 ?D1)) (number ?d2 & ?a1 &~?d1))

    (info (type name) (value GaraOldman) (number ?n1))
    (info (type date) (value ?D3 &~15 &~?D2 &~?D1) (number ?d2 & ?n1 &~))
)

/* 
    ; Asserts all possible values for candidate name and party and speech date and attendees.
    (assert (value name AshleyDale))
    (assert (value name BarronTweed))
    (assert (value name ConnerDawes))
    (assert (value name DanielStead))
    (assert (value name EdithFrayle))
    (assert (value name FredMaddox))
    (assert (value name GaraOldman))

    (assert (value date 14))
    (assert (value date 15))
    (assert (value date 16))
    (assert (value date 17))
    (assert (value date 18))
    (assert (value date 19))
    (assert (value date 20))

    (assert (value party Democrat))
    (assert (value party Independent))
    (assert (value party Libertarian))
    (assert (value party Objectivist))
    (assert (value party Reformist))
    (assert (value party Republican))
    (assert (value party Socialist))

    (assert (value attendees 850))
    (assert (value attendees 1200))
    (assert (value attendees 1450))
    (assert (value attendees 1600))
    (assert (value attendees 1875))
    (assert (value attendees 2250))
    (assert (value attendees 2600))
*/