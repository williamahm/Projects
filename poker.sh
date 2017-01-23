#!/bin/bash


##
#This program was created as part of a university assignment submitted in 2015
#This program will deal two five-card poker hands, one to a user and one to the dealer. The program should evaluate each hand, and determine which is the better hand. The user will play against the computer (dealer) 10 times keeping track of who has the better hand each time. The program will then display which player won the most out of 10 games. 
#The program should have the following functions to:
#	Determine if the hand contains a pair
#	Determine if the hand contains two pairs
#	Determine if the hand contains three of a kind (e.g., three jacks)
#	Determine if the hand contains four of a kind (e.g., four aces)
#	Determine if the hand contains a flush (i.e., all five cards of the same suit)
#	Determine if the hand contains a straight (i.e., five cards of consecutive face values)
#The program should print to the output screen each card in the hand and if the hand contains a pair, two pairs, three of a kind, four of a kind, a flush, or a straight.
#The next task will be to create a function(s) that compares the two hands to see which one is better. This process will continue until 10 games are completed. The program should then display if the player or the computer (dealer) has won the best of 10 games.
#The following list shows the value of poker hands from highest to lowest:
#1.	Royal Flush - highest
#2.	Straight Flush
#3.	Four of a kind
#4.	Full House
#5.	Flush
#6.	Straight
#7.	Three of a kind
#8.	Two pair
#9.	Pair
#10.	High card – Lowest
#
##

##
#Creates an array with all of the cards in a deckOfCards
##
function buildDeck
{

deckOfCards=( "s2" "s3" "s4" "s5" "s6" "s7" "s8" "s9" "s10" "sA" "sK" "sQ" "sJ" 
						  "h2" "h3" "h4" "h5" "h6" "h7" "h8" "h9" "h10" "hA" "hK" "hQ" "hJ"
						  "d2" "h3" "d4" "d5" "d6" "d7" "d8" "d9" "d10" "dA" "dK" "dQ" "dJ"
						  "c2" "c3" "c4" "c5" "c6" "c7" "c8" "c9" "c10" "cA" "cK" "cQ" "cJ")						  
}
##
#Welcomes the user and asks them for their name, with error checking
##
function welcome 
{
	nameValid=false
	echo "Welcome to the poker game"
	sleep 1
	echo "Please enter your name"
	read name

	if [[ $name =~ ^[a-z|A-Z]+$ ]];
	then
			nameValid=true;
	fi 
	
	while  [ $nameValid == "false" ] ;
	do	
		echo "Error invalid name entered please try again";
		read name
		if [[ $name =~ ^[a-z|A-Z]+$ ]];
		then
			nameValid=true;
		fi 
	done

	echo "Hello $name"
	sleep 1
	echo "This poker game is best of ten hands, are you ready to start the game?"
	sleep 2
	echo "Press enter to begin"
	read
}

##
#Removes the specified card that has been passed from the array
#containing the deck of cards
##
winner="draw";
playerAceLow=false;
comAceLow=false;
function removeCardFromDeck
{
	deckOfCards=(${deckOfCards[@]/$1})
}

##
#Deals a total of ten cards, five to each the player and dealer
##
function dealCards
{
	dealToPlayer=true; 
	playerHand=()
	comHand=();
	dealtCards=()


	for (( c=1; c<=10; c++ )) 
		do
			X=${deckOfCards[$RANDOM % ${#deckOfCards[@]}]}
		
			if [ $dealToPlayer = "true" ];
			then
				playerHand+=($X)	
				dealToPlayer=false; 	
				echo "$name recieves a card, you got $X"				
				sleep 1.5				
			else
				comHand+=($X)
				dealToPlayer=true; 
				echo "Computer recieves a card"
				sleep 1
			fi
		removeCardFromDeck $X	
		dealtCards+=($X);
	done
}

##
#Used to remove a pair from the current hand being evaluated
##
function removePairFromHand
{	
	currentHand=( ${currentHand[@]/$1/} )
	currentHand=( ${currentHand[@]/$2/} )
}
##
#Used to remove the card parsed from the current hand
##
function removeCardFromHand
{
	currentHand=( ${currentHand[@]/$1/} )
}


comNumPairs=0
comPairs=()
comCardsLeftFromPair=();
playerNumPairs=0
playerPairs=()
playerCardsLeftFromPair=();
alreadyAdded=false;
twoCardIdentical=false;
threeCardIdentical=false;
okToRemove=false;
cardsRemoved=(0);
inTheBlacklist=1;
##
#Used to determine if the hand compares a pair
##
function pair
{
	alreadyFoundPair=(0);
	alreadyExists=0;
	toManyCards=false;
	cardIdentical=false;
	isPair=false;
	cantRemove=(0);
	threeOfAKind=false;
	
	if [ $1 == "player" ];
	then	
		currentHand=(${playerHand[*]});
	else
		currentHand=(${comHand[*]});
	fi
	

	sameCard=1;
	for (( c=0; c<${#currentHand[@]}; c++ )) 
			do			
				for (( i=0; i<${#currentHand[@]}; i++))
					do	
						if [ $c -eq $i ];
							then												
								twoCardIdentical=true;
							else
								twoCardIdentical=false;
							fi					
							
								if [ ${currentHand[c]:1} = ${currentHand[i]:1} ] && [ $twoCardIdentical = false ] ;
								then
									isPair=true;
								else
									isPair=false
								fi		
							
					if [ $isPair = true ] ;
					then
						for (( p=0; p<${#currentHand[@]}; p++))
							do						
													
							 if [ $c -eq $i ] || [ $c -eq $p ] || [ $i -eq $p ];
								then
											threeCardIdentical=true;		
										else
											threeCardIdentical=false;
								fi	
							
							
							
							if [ $threeCardIdentical = false ];
							then
								if [ ${currentHand[c]:1} = ${currentHand[p]:1} ]; ##if the card has a third card equal to it (three of a kind)
								then
									threeOfAKind=true;
									isPair=false;
									alreadyExists=$((alreadyExists+1));					
								
									
									for (( w=0; w<${#cantRemove[@]}; w++))
									do									
										if [ ${currentHand[c]:1} == ${cantRemove[w]} ]; #if the card is in the blacklist 
										then
											inTheBlacklist=$((inTheBlacklist+1))
											break;			
										fi
						
									done
								
									
									if [ "$inTheBlackList" != "0" ]; #if not add it
									then
										cantRemove+=(${currentHand[$c]:1});
										inTheBlackList=0;
									fi					
									okToRemove=false;									
								fi										
							fi						
							
							
							checkFlag=0;	
							for (( w=0; w<${#cantRemove[@]}; w++))
								do		
									if [ $isPair == "true" ] && [ "${currentHand[c]:1}" == "${cantRemove[w]}" ];
									then									
										checkFlag=$((checkFlag+1))
									fi	
								done						
							done
									else
							checkFlag=1;
							fi
						
							if [ $checkFlag == 0 ] && [ $isPair == "true" ];
							then								
								if [ $1 == "player" ];
								then										
									playerNumPairs=$((playerNumPairs + 1))
									playerPairs+=(${currentHand[$c]});
									playerPairs+=(${currentHand[$i]});
									
									
								else
									comNumPairs=$((comNumPairs + 1))
									comPairs+=(${currentHand[$c]});
									comPairs+=(${currentHand[$i]});
									
								fi
								removePairFromHand ${currentHand[$c]} ${currentHand[$i]};
							fi
						done
					done


	if [ $1 == "player" ];
	then	
		playerCardsLeftFromPair=(${currentHand[*]});
		
	else
		comCardsLeftFromPair=(${currentHand[*]});
		
	fi
}

playerCardValues=();
comCardValues=();
##
#Used for returning the value of each card in a hand
#so they can be compared when the ace value is known
##
function cardValuesForComparison
{
 	declare -a argAry1=("${!2}")
	aceLow=false;
	
	currentHand=(${argAry1[*]});
	
	currentHandValues=();
	for (( c=0; c<${#currentHand[@]}; c++ )) 
		do
		case ${currentHand[c]:1} in
		2) 
			currentHandValues+=(2);
			;;
		3) 
			currentHandValues+=(3);
			;;
		4) 
			currentHandValues+=(4);
			;;
		5) 
			currentHandValues+=(5);
			;;
		6) 
			currentHandValues+=(6);
			;;
		7) 
			currentHandValues+=(7);
			;;
		8) 
			currentHandValues+=(8);
			;;
		9) 
			currentHandValues+=(9);
			;;
		10) 
			currentHandValues+=(10);
			;;
		"J") 
			currentHandValues+=(11);
			;;
		"Q") 
			currentHandValues+=(12);
			;;
		"K") 
			currentHandValues+=(13);
			;;
			esac
			
			if [ $playerAceLow == "false" ] || [ $comAceLow == "false" ];
			then
					playerAceLow="false";
					comAceLow="false";
						
						if [ ${currentHand[c]:1} == "A" ];
						then
							currentHandValues+=(14);
						fi
			fi
			if [ $playerAceLow == "true" ] || [ $comAceLow == "true" ];
			then
				if [ ${currentHand[c]:1} == "A" ];
				then
					currentHandValues+=(1);
					fi
			fi
	
	done	 

	if [ $1 == "player" ];
	then	
		playerCardValues=("${currentHandValues[@]}")  
	else
		comCardValues=("${currentHandValues[@]}") 
	fi
}

playerPair=();
playerGreatest="0";
comGreatest="0";
t="0";
##
#Used to compare the remainder of cards if both hands are similiar e.g. both have pairs
##
function compareRemainder
{
	declare -a argAry1=("${!1}")
	playerCardsLeft=(${argAry1[*]});
	
	declare -a argAry2=("${!2}")
	comCardsLeft=(${argAry2[*]});
	
	cardValuesForComparison "player" playerCardsLeft[@] 
	
 for (( i=0; i<${#playerCardValues[@]}; i++ )) 
		do
			for (( j=0; j<${#playerCardValues[@]}; j++ )) 
			do
				if [ ${playerCardValues[i]} -gt ${playerCardValues[j]} ]; 
				then
					t=${playerCardValues[i]}
					playerCardValues[i]=${playerCardValues[j]}
					playerCardValues[j]=$t
				fi
		done
	done
	
	
	
	cardValuesForComparison "computer" comCardsLeft[@] 
	
	 for (( i=0; i<${#comCardValues[@]}; i++ )) 
		do
			for (( j=0; j<${#comCardValues[@]}; j++ )) 
			do
				if [ ${comCardValues[i]} -gt ${comCardValues[j]} ]; 
				then
					t=${comCardValues[i]}
					comCardValues[i]=${comCardValues[j]}
					comCardValues[j]=$t
				fi
		done
	done			
		
	 for (( i=0; i<${#comCardValues[@]}; i++ )) 
		do
			if [ ${playerCardValues[i]} -gt ${comCardValues[i]} ]; 
				then
					winner="player"
					break
				elif [ ${playerCardValues[i]} -lt ${comCardValues[i]} ]; 
					then
					winner="computer"
					break;
					else
						continue;
				fi			
		done
}


playerHandValue=0;
comHandValue=0;
highestCard=0;
numBased=false;
##
#The method that is called when player have hands of similiar values e.g. both four of a kind
#This method will decide based on the parsed information, what comparisons to do 
##
function compareHands
{
	if [ $1 == "pairs" ];
	then
			compareRemainder playerPairs[@] comPairs[@]
	fi
	
	if [ $1 == "pairsRemainder" ];
	then
		compareRemainder playerCardsLeftFromPair[@] comCardsLeftFromPair[@] 
	fi
	
	if [ $1 == "threeOfAKind" ];
	then		
		cardValuesForComparison "player" playerThreeOfAKindCards[@] 
		cardValuesForComparison "computer" comThreeOfAKindCards[@]
		
		if [ ${playerCardValues[0]} -gt ${comCardValues[0]} ] ;
		then
			winner="player"
		else
			winner="computer"			
		fi
	fi
	
	if [ $1 == "fourOfAKind" ];
	then
		comAceLow=false;
		playerAceLow=false;
		cardValuesForComparison "player" playerFourOfAKindCards[@] 
		cardValuesForComparison "computer" comFourOfAKindCards[@]
		
		if [ ${playerCardValues[0]} -gt ${comCardValues[0]} ] ;
		then
			winner="player"
		else
			winner="computer"			
		fi
	fi
	
	if [ $1 == "straight" ];
	then
		compareRemainder playerHand[@] comHand[@];
	fi
}



playerThreeOfAKind=false;
comThreeOfAKind=false;
playerThreeOfAKindCards=()
comThreeOfAKindCards=()
##
#Used to detect whether or not a hand has three of a kind
##
function threeOfAKind
{
	cardIdentical=false;
	isThreeOfAKind=false;
	if [ $1 == "player" ];
	then	
		currentHand=(${playerHand[*]});
	else
		currentHand=(${comHand[*]});
	fi
	
	for (( c=0; c<${#currentHand[@]}; c++ )) 
			do		
				for (( i=0; i<${#currentHand[@]}; i++))
					do
						for (( p=0; p<${#currentHand[@]}; p++))
						do
							if [ $c -eq $i ] || [ $c -eq $p ] || [ $i -eq $p ];
							then						
								cardIdentical=true;		
							else
								cardIdentical=false;
							fi													
								
						
							if [ ${currentHand[c]:1} = ${currentHand[i]:1} ] && [ ${currentHand[c]:1} = ${currentHand[p]:1} ]
							then
								isThreeOfAKind=true
							else
								isThreeOfAKind=false
							fi
							
							if [ $isThreeOfAKind = true ] && [ $cardIdentical != true ];
							then								 
							
								if [ $1 == "player" ];
								then	
									playerThreeOfAKind=true;					
									playerThreeOfAKindCards+=(${currentHand[$c]});
									playerThreeOfAKindCards+=(${currentHand[$i]});
									playerThreeOfAKindCards+=(${currentHand[$p]});	
									
								else
									comThreeOfAKind=true;															
									comThreeOfAKindCards+=(${currentHand[$c]});
									comThreeOfAKindCards+=(${currentHand[$i]});
									comThreeOfAKindCards+=(${currentHand[$p]});										
								fi
									removeCardFromHand ${currentHand[$c]} #Remove only one cards so three of a kind won't show up again
									fi
						done							
					done
	done

}

playerFourOfAKind=false;
comFourOfAKind=false;
playerFourOfAKindCards=()
comFourOfAKindCards=()
##
#Used to detct whether or not a hand has four of a kind
##
function fourOfAKind
{	
	cardIdentical=false;
	isFourOfAKind=false;
	if [ $1 == "player" ];
	then	
		currentHand=(${playerHand[*]});
	else
		currentHand=(${comHand[*]});
	fi
	
	for (( c=0; c<${#currentHand[@]}; c++ )) 
			do		
				for (( i=0; i<${#currentHand[@]}; i++))
					do
						for (( p=0; p<${#currentHand[@]}; p++))
						do
							for (( b=0; b<${#currentHand[@]}; b++))
								do
								if [ $c -eq $i ] || [ $c -eq $p ] || [ $c -eq $b ] || [ $i -eq $p ]|| [ $i -eq $b ] || [ $p -eq $b ]; 
								then						
									cardIdentical=true;		#Stops cards being compared against themselves for invalid results
								else
									cardIdentical=false;
								fi		
								
								if [ ${currentHand[c]:1} = ${currentHand[i]:1} ] && [ ${currentHand[c]:1} = ${currentHand[p]:1} ] && [ ${currentHand[c]:1} = ${currentHand[b]:1} ]
								then
									isFourOfAKind=true
									
								else
									isFourOfAKind=false
								fi
							
								if [ $isFourOfAKind = true ] && [ $cardIdentical != true ];
								then
								if [ $1 == "player" ];
								then	
									playerFourOfAKind=true;							
									playerFourOfAKindCards+=(${currentHand[$c]});
									playerFourOfAKindCards+=(${currentHand[$i]});
									playerFourOfAKindCards+=(${currentHand[$p]});	
									playerFourOfAKindCards+=(${currentHand[$b]});
									
								else
									comFourOfAkind=true;
																	
									comFourOfAKindCards+=(${currentHand[$c]});
									comFourOfAKindCards+=(${currentHand[$i]});
									comFourOfAKindCards+=(${currentHand[$p]});
									comFourOfAKindCards+=(${currentHand[$b]});							

								fi
									removeCardFromHand ${currentHand[$c]} #Remove only one cards so four of a kind no longer possible							
								
								fi						
								
								done						
						done
				done
		done
		
}

playerHasFlush=false;
playerFlushBiggest="";
comHasFlush=false;
comFlushBiggest="";
##
#Finds out if a hand has a flush
##
function flush #If the cards are in the same suite then it is a flush
{
	sameSuite="1";
		if [ $1 == "player" ];
		then	
			currentHand=(${playerHand[*]});
		else
			currentHand=(${comHand[*]});
		fi

	for (( c=1; c<=${#currentHand[@]}; c++ )) 
		do	
			if [ "${currentHand[0]:0:1}" == "${currentHand[c]:0:1}" ];
			then
			sameSuite=$((sameSuite + 1))
			fi
	done

	if [ $sameSuite == "5" ];
	then
		if [ $1 == "player" ];
		then	
			playerHasFlush=true;
		else
			comHasFlush=true;			
		fi
	fi
	
}

comHandValues=();
playerHandValues=();
aceLow=true;
##
#Returns the values of the cards and the ace is equal to one 
##
function cardValuesAceLow
{
	aceLow=true;
	if [ $1 == "player" ];
	then	
		currentHand=(${playerHand[*]});
	else
		currentHand=(${comHand[*]});
	fi
	
	currentHandValues=();
	for (( c=0; c<${#currentHand[@]}; c++ )) 
		do
		case ${currentHand[c]:1} in
		"A") 
			currentHandValues+=(1);
			;;
		2) 
			currentHandValues+=(2);
			;;
		3) 
			currentHandValues+=(3);
			;;
		4) 
			currentHandValues+=(4);
			;;
		5) 
			currentHandValues+=(5);
			;;
		6) 
			currentHandValues+=(6);
			;;
		7) 
			currentHandValues+=(7);
			;;
		8) 
			currentHandValues+=(8);
			;;
		9) 
			currentHandValues+=(9);
			;;
		10) 
			currentHandValues+=(10);
			;;
		"J") 
			currentHandValues+=(11);
			;;
		"Q") 
			currentHandValues+=(12);
			;;
		"K") 
			currentHandValues+=(13);
			;;

		esac
	done


	if [ $1 == "player" ];
	then	
		playerHandValues=("${currentHandValues[@]}")  
	else
		comHandValues=("${currentHandValues[@]}") 
	fi
}
##
#Returns the values of the cards and the ace is equal to 14 
##
function cardValuesAceHigh
{
	aceLow=false;
	if [ $1 == "player" ];
	then	
		currentHand=(${playerHand[*]});
	else
		currentHand=(${comHand[*]});
	fi
	
	currentHandValues=();
	for (( c=0; c<${#currentHand[@]}; c++ )) 
		do
		case ${currentHand[c]:1} in
		2) 
			currentHandValues+=(2);
			;;
		3) 
			currentHandValues+=(3);
			;;
		4) 
			currentHandValues+=(4);
			;;
		5) 
			currentHandValues+=(5);
			;;
		6) 
			currentHandValues+=(6);
			;;
		7) 
			currentHandValues+=(7);
			;;
		8) 
			currentHandValues+=(8);
			;;
		9) 
			currentHandValues+=(9);
			;;
		10) 
			currentHandValues+=(10);
			;;
		"J") 
			currentHandValues+=(11);
			;;
		"Q") 
			currentHandValues+=(12);
			;;
		"K") 
			currentHandValues+=(13);
			;;
		"A") 
			currentHandValues+=(14);
			;;

		esac
	done
	 

	if [ $1 == "player" ];
	then	
		playerHandValues=("${currentHandValues[@]}")  
	else
		comHandValues=("${currentHandValues[@]}") 
	fi
}

playerStraight=false;
playerStraightFlush=false;
playerRoyalFlush=false;
playerStraightFlushHighest="";

comStraight=false;
comStraightFlush=false;
comRoyalFlush=false;
comStraightFlushHighest="";
##
#Decides if the hand contains either a straight or royal flush
##
function straightOrRoyalFlush
{
	straight=false;
	if [ $1 == "player" ];
	then	
		currentHand=(${playerHandValues[*]});
	else
		currentHand=(${comHandValues[*]});
	fi
	

	biggest=${currentHand[0]};
	#echo $biggest;
	for (( c=0; c<${#currentHand[@]}; c++ )) 
		do	
			if [ ${currentHand[$c]} -gt $biggest ];
			 then
				 	biggest=${currentHand[$c]};
			 fi
		done


	smallest=${currentHand[0]};
	for (( c=0; c<${#currentHand[@]}; c++ )) 
		do	
			if [ ${currentHand[$c]} -lt $smallest ];
			 then
				 	smallest=${currentHand[$c]};
			 fi
		done

	range=`echo $biggest - $smallest | bc`

	if [ $range -eq "4" ]; #The range will always be 4 if the player has a straight
	then 
		straight=true;
	fi

	if [ $straight == "true" ];
	then		
		if [ $1 == "player" ];
		then	
			playerStraight=true;
			playerStraightFlushHighest="$biggest";
			
			if [ $playerHasFlush == "true" ]; 
			then
				playerStraightFlush=true;
				if [ $biggest -eq "14" ];
				 then
					playerRoyalFlush=true;
					playerStraightFlush=false;
				fi		
			fi	
	else
			comStraight=true;
			comStraightFlushHighest="$biggest";
		
				if [ $comHasFlush == "true" ];
				then
					comStraightFlush=true;
					if [ $biggest -eq "14" ]; 
					then
						comRoyalFlush=true;
						comStraightFlush=false;
					fi	
				fi	
			fi	
		fi
}

##
#Runs the appropriate methods to check if either the player or dealer has a flush 
#because the ACE can equal 1 or 14 in value, this is recorded in the AceLow booleans for player and computer
##
function checkFlushes
{
	flush "player";
	flush "computer";
	
	if [ $playerNumPairs -eq 0 ] && [ $playerThreeOfAKind = false ] && [ $playerFourOfAKind = false ];
	 then
			cardValuesAceLow "player"
			straightOrRoyalFlush "player";
			
			if [ $playerStraight == "true" ]; then
				playerAceLow=true;
			
			cardValuesAceHigh "player"
			straightOrRoyalFlush "player"
			
		fi
	fi
	
	if [ $comNumPairs -eq 0 ] && [ $comThreeOfAKind = false ] && [ $comFourOfAKind = false ] ; then	
		#if [ $comHasFlush == "true" ]; then
		
			cardValuesAceLow "computer"
			straightOrRoyalFlush "computer";
			
			if [ $comStraight == "true" ]; then
				comAceLow=true;
			fi			
		
			cardValuesAceHigh "computer"		
			straightOrRoyalFlush "computer";
		#fi
	fi
	
	

	if [ $playerStraight == "true" ] && [ $comStraight == "true" ]; 
	then
		compareRemainder playerHand[@] comHand[@];	
	fi	
}
##
##
#Calls all of the methods necessary to detect the information about each hand
##
function checkHands
{
	pair "player"
	pair "computer"

	threeOfAKind "player"
	threeOfAKind "computer"

	fourOfAKind "player"
	fourOfAKind "computer"

	checkFlushes;	
}

function debug 
{
echo "DEBUG VARIABLES";
	
	echo "playerNumPairs : $playerNumPairs";
	echo "playerThreeOfAKind : $playerThreeOfAKind";
	echo "playerFourOfAkind : $playerFourOfAkind";
	echo "playerFullHouse : $playerFullHouse";
	echo "playerHasFlush : $playerHasFlush";
	echo "playerStraight : $playerStraight";
	echo "playerStraightFlush : $playerStraightFlush";
	echo "playerRoyalFlush : $playerRoyalFlush";
	echo "playerAceLow : $playerAceLow";
	echo "-----------------------------"
	echo "comNumPairs : $comNumPairs";
	echo "comHasFlush : $comHasFlush";
	echo "comThreeOfAKind : $comThreeOfAKind";
	echo "comFourOfAKind : $comFourOfAKind";
	echo "comFullHouse : $comFullHouse";	
	echo "comStraight : $comStraight";
	echo "comStraightFlush : $comStraightFlush";
	echo "comRoyalFlush : $comRoyalFlush";
	echo "comAceLow : $comAceLow";
}
##
#Uses a range of if statements going through each hand rank, whether a hand has that rank
#and then deciding who has the highest hand and who wins
## 
function decideWinner
{
	comFullHouse=false;
	playerFullHouse=false;
	playerAceLow=false;
	comAceLow=false;

	if [ $comNumPairs -eq "1" ] && [ $comThreeOfAKind == "true" ];
	then
		comFullHouse=true;	
	fi
	
	
	if [ $playerNumPairs -eq "1" ] && [ $playerThreeOfAKind == "true" ];
	then
		playerFullHouse=true;	
	fi


	winnerDecided=false;
	winningHand="";
	
	if [ $comRoyalFlush == "true" ] && [ $playerRoyalFlush == "true" ] && [ $winnerDecided == "false" ];
	then
		winner="draw"
		winnerDecided=true;
		winningHand="royal flush"
	fi
	
	if [ $comRoyalFlush == "false" ] && [ $playerRoyalFlush == "true" ] && [ $winnerDecided == "false" ];
	then
		winner="player"
		winnerDecided=true;
		winningHand="royal flush"
	fi
	
	if [ $comRoyalFlush == "true" ] && [ $playerRoyalFlush == "false" ] && [ $winnerDecided == "false" ];
	then
		winner="computer"
		winnerDecided=true;
		winningHand="royal flush"
	fi
	
	if [ $comStraightFlush == "true" ] && [ $playerStraightFlush == "true" ] && [ $winnerDecided == "false" ];
	then
		compareHands "straight"
		winnerDecided=true;
		winningHand="straight flush"
	fi
	
	if [ $comStraightFlush == "false" ] && [ $playerStraightFlush == "true" ] && [ $winnerDecided == "false" ];
	then
		winner="player"
		winnerDecided=true;
		winningHand="straight flush"
	fi
	
	if [ $comStraightFlush == "true" ] && [ $playerStraightFlush == "false" ] && [ $winnerDecided == "false" ];
	then
		winner="computer"
		winnerDecided=true;
		winningHand="straight flush"
	fi
	
	if [ $comFourOfAKind == "true" ] && [ $playerFourOfAKind == "true" ] && [ $winnerDecided == "false" ];
	then
		compareHands "fourOfAKind"
		winnerDecided=true;
		winningHand="four of a kind"
	fi
	
	if [ $comFourOfAKind == "false" ] && [ $playerFourOfAKind == "true" ] && [ $winnerDecided == "false" ];
	then
		winner="player"
		winnerDecided=true;
		winningHand="four of a kind"
	fi
	
	if [ $comFourOfAKind == "true" ] && [ $playerFourOfAKind == "false" ] && [ $winnerDecided == "false" ];
	then
		winner="computer"
		winnerDecided=true;
		winningHand="four of a kind"
	fi	
	
	if [ $comFullHouse == "true" ] && [ $playerFullHouse == "true" ] && [ $winnerDecided == "false" ];
	then
		compareHands "straight"
		winnerDecided=true;
		winningHand="full house"
	fi
	
	if [ $comFullHouse == "false" ] && [ $playerFullHouse == "true" ] && [ $winnerDecided == "false" ];
	then
		winner="player"
		winnerDecided=true;
		winningHand="full house"
	fi
	
	if [ $comFullHouse == "true" ] && [ $playerFullHouse == "false" ] && [ $winnerDecided == "false" ];
	then
		winner="computer"
		winnerDecided=true;
		winningHand="full house"
	fi
	
	
	if [ $comFullHouse == "true" ] && [ $playerFullHouse == "false" ] && [ $winnerDecided == "false" ];
	then
		winner="computer"
		winnerDecided=true;
		winningHand="full house"
	fi
	
	if [ $comHasFlush == "true" ] && [ $playerHasFlush == "true" ] && [ $winnerDecided == "false" ];
	then
		compareHands "straight"
		winnerDecided=true;
		winningHand="flush"
	fi
	
	if [ $comHasFlush == "false" ] && [ $playerHasFlush == "true" ] && [ $winnerDecided == "false" ];
	then
		winner="player"
		winnerDecided=true;
		winningHand="flush"
	fi
	
	if [ $comHasFlush == "true" ] && [ $playerHasFlush == "false" ] && [ $winnerDecided == "false" ];
	then
		winner="computer"
		winnerDecided=true;
		winningHand="flush"
	fi
	
	if [ $comStraight == "true" ] && [ $playerStraight == "true" ] && [ $winnerDecided == "false" ];
	then
		compareHands "straight"
		winnerDecided=true;
		winningHand="straight"
	fi
	
	if [ $comStraight == "false" ] && [ $playerStraight == "true" ] && [ $winnerDecided == "false" ];
	then
		winner="player"
		winnerDecided=true;
		winningHand="straight"
	fi
	
	if [ $comStraight == "true" ] && [ $playerStraight == "false" ] && [ $winnerDecided == "false" ];
	then
		winner="computer"
		winnerDecided=true;
		winningHand="straight"
	fi
		
		
	if [ $comThreeOfAKind == "true" ] && [ $playerThreeOfAKind == "true" ] && [ $winnerDecided == "false" ];
	then
		compareHands "straight"
		winnerDecided=true;
		winningHand="three of a kind"
	fi
	
	if [ $comThreeOfAKind == "false" ] && [ $playerThreeOfAKind == "true" ] && [ $winnerDecided == "false" ];
	then
		winner="player"
		winnerDecided=true;
		winningHand="three of a kind"
	fi
	
	if [ $comThreeOfAKind == "true" ] && [ $playerThreeOfAKind == "false" ] && [ $winnerDecided == "false" ];
	then
		winner="computer"
		winnerDecided=true;
		winningHand="three of a kind"
	fi
	
	if [ $comNumPairs -eq $playerNumPairs  ] && [ $comNumPairs -eq 1 ] && [ $winnerDecided == "false" ];
	then
			winnerDecided=true;
			compareHands "pairs"			
			winningHand="a pair"		
		if [ $winner == "draw" ];
		then
			compareHands "pairsRemainder"
		fi	
		
	fi
	
	if [ $comNumPairs -eq $playerNumPairs  ] && [ $comNumPairs -eq 2 ] && [ $winnerDecided == "false" ];
	then			
			compareHands "pairs"
			winnerDecided=true;
			winningHand="pairs"
		
		
		if [ $winner == "draw" ];
		then
			compareHands "pairsRemainder"
		fi		
	fi
	
	if [ $comNumPairs -lt $playerNumPairs ] && [ $winnerDecided == "false" ];
	then
		winner="player"		
		winnerDecided=true;
		winningHand="pairs"
	fi
	
	if [ $comNumPairs -gt $playerNumPairs ] && [ $winnerDecided == "false" ];
	then
		winner="computer"

		winnerDecided=true;
		winningHand="pairs"
	fi
	
	if [ $winnerDecided == "false" ]
	then
		compareHands "straight"
		winnerDecided=true;
		winningHand="single"	
	fi
	
	
}	
	 


##
#Used to display the appropriate message specific to each players hand
##
function showFindings
{
	echo "Players hand is made up of the following cards "
	echo ${playerHand[@]}
	
	sleep 2
	
	if [ $playerNumPairs -eq 1 ];
	then
		echo "Player has one pair : ${playerPairs[@]}"
	fi
	
	if [ $playerNumPairs -eq 2 ];
	then
		echo "Player has two pairs : ${playerPairs[@]}"
	fi
	
	if [ $playerThreeOfAKind == "true" ];
	then
		echo "Player has three of a kind : ${playerThreeOfAKindCards[@]}"
	fi
	
	if [ $playerFourOfAKind == "true" ];
	then
		echo "Player has four of a kind : ${playerFourOfAKindCards[@]}"
	fi
	
	if [ $playerHasFlush == "true" ]; 
	then
		echo "Player has a flush : ${playerHand[@]}"
	fi
	
	if [ $playerStraight == "true" ]; #Maybe Re-arrange the hand to look like a straight
	then
		echo "Player has a straight : ${playerHand[@]}"
	fi
	
	if [ $playerRoyalFlush == "true" ]; #Maybe Re-arrange too
	then
		echo "Player has a straight : ${playerHand[@]}"
	fi
		
	
	echo "Computers hand is made up of the following cards "
	echo ${comHand[@]}
	
	sleep 2
	
		if [ $comNumPairs -eq 1 ];
	then
		echo "Computer has one pair : ${comPairs[@]}"
	fi
	
	if [ $comNumPairs -eq 2 ];
	then
		echo "Computer has two pairs : ${comPairs[@]}"
	fi
	
	if [ $comThreeOfAKind == "true" ];
	then
		echo "Computer has three of a kind : ${comThreeOfAKindCards[@]}"
	fi
	
	if [ $comFourOfAKind == "true" ];
	then
		echo "Computer has four of a kind : ${comFourOfAKindCards[@]}"
	fi
	
	if [ $comHasFlush == "true" ]; 
	then
		echo "Computer has a flush : ${comHand[@]}"
	fi
	
	if [ $comStraight == "true" ]; 
	then
		echo "Computer has a straight : ${comHand[@]}"
	fi
	
	if [ $comRoyalFlush == "true" ]; 
	then
		echo "Computer has a straight : ${comHand[@]}"
	fi
}
##
#Resets the program variables to their beginning state so the program can run again
##
function resetVariables
{

	unset playerHand
	unset comHand
	
	playerHand=()
	comHand=()

	#Variables related to pairs function
	
	alreadyAdded=false;
	twoCardIdentical=false;
	threeCardIdentical=false;
	okToRemove=false;
	inTheBlacklist=1;
	
	threeOfAKind=false;

	unset cardsRemoved
	unset cantRemove
	
	unset playerPairs
	unset playerCardsLeftFromPair
	
	unset comPairs
	unset comCardsLeftFromPair
	
	cardsRemoved=(0);
	cantRemove=(0);
	
	playerCardsLeftFromPair=()
	playerPairs=()
	
	comPairs=()
	comCardsLeftFromPair=()
	
	#Variables related to threeOfAKind function
	
	unset playerThreeOfAKindCards
	unset comThreeOfAKindCards
	
	playerThreeOfAKindCards=()
	comThreeOfAKindCards=()
	
	
	#Variables related to fourOfAKind function
	
	
	unset playerFourOfAKindCards
	unset comFourOfAKindCards
	
	playerFourOfAKindCards=()
	comFourOfAKindCards=()
	
	#Variables related to flush funciton
	playerFlushBiggest="";
	comFlushBiggest="";
	
	
	#Hand Comparison variables
	playerNumPairs=0;
	playerThreeOfAKind=false;
	playerFourOfAkind=false;
	playerFullHouse=false;
	playerHasFlush=false;
	playerStraight=false;
	playerStraightFlush=false;
	playerRoyalFlush=false;
	playerAceLow=false;
	

	
	comNumPairs=0;
	comHasFlush=false;
	comThreeOfAKind=false;
	comFourOfAKind=false;
	comFullHouse=false;	
	comStraight=false;
	comStraightFlush=false;
	comRoyalFlush=false;
	comAceLow=false;


}

playerGamesWon=0;
comGamesWon=0;
##
#Used to play one game, since 10 are played it is called 10 times
##
function playGame 
{
	echo "###### Game $gamesPlayed ######"
	buildDeck	
	dealCards	
	checkHands
	showFindings
	decideWinner
	echo "The winner is $winner with $winningHand"
	if [ $winner == "player" ];
	then
		playerGamesWon=$((playerGamesWon+1))
	else
		comGamesWon=$((comGamesWon+1))
	fi
	if [ $gamesPlayed -le 9 ];
	then
		echo "$name:$playerGamesWon      Computer:$comGamesWon"	
	fi
	sleep 2
}
############################################################################################# 
#debug
#playerHand=( "sA" "cK" "c10" "c9" "s8") # TEMPORARY HAND FOR TESTING PURPOSES
#comHand=( "cJ" "hK" "s4" "d5" "c4") # TEMPORARY HAND FOR TESTING PURPOSES


gamesPlayed=1;

welcome

	while [ "$gamesPlayed" -lt 11 ]
	do
		playGame
		sleep 1
		gamesPlayed=$((gamesPlayed+1))
		resetVariables
	done


	if [ $playerGamesWon -eq $comGamesWon ];
	then
		echo "There is no winner! The game is a tie."
	fi

	if [ $playerGamesWon -gt $comGamesWon ];
	then
		echo "The winner of the game is $name!"
	fi

	if [ $playerGamesWon -lt $comGamesWon ];
	then
		echo "The winner of the game is the computer!"
	fi

	echo "$name:$playerGamesWon      computer:$comGamesWon"	
 


#############################################################################################


 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
