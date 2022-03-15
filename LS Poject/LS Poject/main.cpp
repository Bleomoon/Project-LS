#include <stdio.h>

#include "aexp.h"
#include "bexp.h"
#include "valuation.h"

void ainterp(aexp* exp, valuation v);
void asubst(const std::string name, aexp* bigExp, aexp* replaceExp);

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
	std::string rt;
	exp1.aexp_to_string(rt);
	std::cout << rt << std::endl;
	rt.clear();
	exp2.aexp_to_string(rt);
	std::cout << rt << std::endl;
	rt.clear();
	exp3.aexp_to_string(rt);
	std::cout << rt << std::endl;
	rt.clear();
	exp4.aexp_to_string(rt);
	std::cout << rt << std::endl;
	rt.clear();
	exp5.aexp_to_string(rt);
	std::cout << rt << std::endl;
	rt.clear();
	exp6.aexp_to_string(rt);
	std::cout << rt << std::endl;
	rt.clear();
	exp7.aexp_to_string(rt);
	std::cout << rt << std::endl;
	rt.clear();
	exp8.aexp_to_string(rt);
	std::cout << rt << std::endl;
	rt.clear();
	exp9.aexp_to_string(rt);
	std::cout << rt << std::endl;
	rt.clear();

	//we create our valuation
	valuation v = valuation("x", "5");
	v.add("y", "9");

	ainterp(&exp5, v);
	exp5.aexp_to_string(rt);
	std::cout << rt << std::endl;
	rt.clear();

	//we use asubst

	asubst("x", &exp7, new aexp("7"));
	asubst("y", &exp9, new aexp("+", new aexp("z"), new aexp("2")));

	exp7.aexp_to_string(rt);
	std::cout << rt << std::endl;
	rt.clear();

	exp9.aexp_to_string(rt);
	std::cout << rt << std::endl;
	rt.clear();

	//we create bexp expression
	bexp exp1 = bexp("vrai");
	bexp exp1 = bexp("et", new bexp("vrai"), new bexp("faux"));
	bexp exp1 = bexp("non", new bexp("vrai"));
	bexp exp1 = bexp("non", new bexp("vrai"), new bexp("faux"));
	bexp exp1 = bexp("=", new bexp("2"), new bexp("4"));

	bexp exp1 = bexp("=", new bexp("+", new bexp("3"), new bexp("5")), new bexp("*", new bexp("2"), new bexp("4")));
	bexp exp1 = bexp("=", new bexp("*", new bexp("2"), new bexp("x")), new bexp("+", new bexp("y"), new bexp("1")));
	bexp exp1 = bexp("<=", new bexp("5"), new bexp("7"));
	bexp exp1 = bexp("et", new bexp("<=", new bexp("+", new bexp("8"), new bexp("9")), new bexp("*", new bexp("4"), new bexp("5"))), new bexp("<=", new bexp("+", new bexp("3"), new bexp("x")), new bexp("*", new bexp("4"), new bexp("y"))));

}

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