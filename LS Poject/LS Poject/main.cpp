#include <stdio.h>

#include "aexp.h"
#include "bexp.h"
#include "valuation.h"

void ainterp(aexp* exp, valuation v);
void asubst(const std::string name, aexp* bigExp, aexp* replaceExp);
void binterp(bexp* exp, valuation v);
void bsubst(const std::string name, bexp* bigExp, bexp* replaceExp);

int main() {
	//we init our expression
	aexp exp1 = aexp("2");
	aexp exp2 = aexp("+", new aexp("2"), new aexp("3"));
	aexp exp3 = aexp("-", new aexp("2"), new aexp("5"));
	aexp exp4 = aexp("*", new aexp("3"), new aexp("6"));
	aexp exp5 = aexp("+", new aexp("2"), new aexp("x"));
	aexp exp6 = aexp("*", new aexp("4"), new aexp("y"));

	aexp exp7 = aexp("*", new aexp("3"), new aexp("*", new aexp("x"), new aexp("x")));
	aexp exp8 = aexp("+", new aexp("*", new aexp("5"), new aexp("x")), new aexp("*", new aexp("7"), new aexp("y")));
	aexp exp9 = aexp("+", new aexp("*", new aexp("6"), new aexp("x")), new aexp("*", new aexp("5"), new aexp("*", new aexp("y"), new aexp("x"))));

	//We print our strings
	std::cout << exp1.aexp_to_string() << std::endl;
	std::cout << exp2.aexp_to_string() << std::endl;
	std::cout << exp3.aexp_to_string() << std::endl;
	std::cout << exp4.aexp_to_string() << std::endl;
	std::cout << exp5.aexp_to_string() << std::endl;
	std::cout << exp6.aexp_to_string() << std::endl;
	std::cout << exp7.aexp_to_string() << std::endl;
	std::cout << exp8.aexp_to_string() << std::endl;
	std::cout << exp9.aexp_to_string() << std::endl;

	//we create our valuation
	valuation v = valuation("x", "5");
	v.add("y", "9");

	ainterp(&exp5, v);
	std::cout << exp5.aexp_to_string() << std::endl;

	//we use asubst

	asubst("x", &exp7, new aexp("7"));
	asubst("y", &exp9, new aexp("+", new aexp("z"), new aexp("2")));

	std::cout << exp7.aexp_to_string() << std::endl;
	std::cout << exp9.aexp_to_string() << std::endl;

	//we create bexp expression
	bexp exp11 = bexp("vrai");
	bexp exp12 = bexp("et", new bexp("vrai"), new bexp("faux"));
	bexp exp13 = bexp("non", new bexp("vrai"));
	bexp exp14 = bexp("ou", new bexp("vrai"), new bexp("faux"));
	bexp exp15 = bexp("=", new bexp("2"), new bexp("4"));

	bexp exp16 = bexp("=", new bexp("+", new bexp("3"), new bexp("5")), new bexp("*", new bexp("2"), new bexp("4")));
	bexp exp17 = bexp("=", new bexp("*", new bexp("2"), new bexp("x")), new bexp("+", new bexp("y"), new bexp("1")));
	bexp exp18 = bexp("<=", new bexp("5"), new bexp("7"));
	bexp exp19 = bexp("et", new bexp("<=", new bexp("+", new bexp("8"), new bexp("9")), new bexp("*", new bexp("4"), new bexp("5"))), new bexp("<=", new bexp("+", new bexp("3"), new bexp("x")), new bexp("*", new bexp("4"), new bexp("y"))));


	//We print our strings
	std::cout << exp11.bexp_to_string() << std::endl;
	std::cout << exp12.bexp_to_string() << std::endl;
	std::cout << exp13.bexp_to_string() << std::endl;
	std::cout << exp14.bexp_to_string() << std::endl;
	std::cout << exp15.bexp_to_string() << std::endl;
	std::cout << exp16.bexp_to_string() << std::endl;
	std::cout << exp17.bexp_to_string() << std::endl;
	std::cout << exp18.bexp_to_string() << std::endl;
	std::cout << exp19.bexp_to_string() << std::endl;
}

//TODO évalué les résultats2 + 5 renvoie 7 et 2 + x renvoie 2 + x
void ainterp(aexp* exp, valuation v) {
	for (int i = 0; i < v.getVariables().size(); i++) {
		if (exp->getRoot() == v.getVariables().at(i).first) {
			exp->changeRoot(v.getVariables().at(i).second);
		}

		if (exp->getLeft() != nullptr) {
			ainterp(exp->getLeft(), v);
		}
		if (exp->getRight() != nullptr) {
			ainterp(exp->getRight(), v);
		}
	}
}

void asubst(const std::string name, aexp* bigExp, aexp* replaceExp) {
	if (bigExp->getLeft() != nullptr) {
		asubst(name, bigExp->getLeft(), replaceExp);
	}

	if (bigExp->getRight() != nullptr) {
		asubst(name, bigExp->getRight(), replaceExp);
	}

	if (bigExp->getRoot() == name) {
		bigExp->changeRoot(replaceExp->getRoot());
		bigExp->changeRight(replaceExp->getRight());
		bigExp->changeLeft(replaceExp->getLeft());
	}
}

//TODO évalué les résultats vrai et faux renvoie faux en exemple
void binterp(bexp* exp, valuation v) {
	for (int i = 0; i < v.getVariables().size(); i++) {
		if (exp->getRoot() == v.getVariables().at(i).first) {
			exp->changeRoot(v.getVariables().at(i).second);
		}

		if (exp->getLeft() != nullptr) {
			ainterp(exp->getLeft(), v);
		}
		if (exp->getRight() != nullptr) {
			ainterp(exp->getRight(), v);
		}
	}
}