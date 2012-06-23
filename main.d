module main;

import std.stdio;
import std.exception;
import wmachine;

void main(string[] args)
{
	enforce(args.length == 2, "Il faut donner une longueur de ruban.");
	auto turing = new WMachine(to!uint(args[1]));
	
	writeln("Instructions

	< : deplacer la tete de lecture vers la gauche
	> : deplacer la tete de lecture vers la droite
	* : ecrire un  1  sur la case pointee par la tete de lecture
	n : sauter e la n-eme instruction si la case pointee \n 	    par la tete de lecture est  1 
	e : effacer le  1  sur la case pointee par la tete de lecture");
	while(true)
	{
		writeln("Entrez vos instructions");
		write("#: ");
		string code = readln();
		turing.parse(code);
		turing.process();
		writeln(turing.result);
	}
}