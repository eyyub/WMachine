module wmachine;

import std.stdio;
import std.string : isNumeric;
import std.array : split;
import std.conv : to, format;
import std.exception : enforce;

class WMachineError : Error
{
	this(string msg)
	{
		super(msg);
	}
}

interface IMachine
{
	void parse(string expr)
	in
	{	
		assert(expr.length > 0, "Cannot parse a 0-length string");
	}
	void process();
	@property string result();
}

class WMachine : IMachine
{
	private
	{
		string[] _tokens;
		char[]  _ruban;
		
		void initRuban()
		{
			foreach(ref char bit; _ruban)
				bit = '0';	
		}
	}
	public
	{
		this(uint rubanLength)
		{
			_ruban.length = rubanLength;
		}
		void parse(string expr)
		{
			_tokens = split(expr);
		}
		void process()
		{
			uint currentTok;
			uint currentBit;
			initRuban();
			while(currentTok < _tokens.length && currentBit < _ruban.length)
			{
				switch(_tokens[currentTok])
				{
					case "*" :
						_ruban[currentBit] = '1';
						break;
					case ">" :
						++currentBit;
						break;
					case "<" :
						 if(currentBit > 0) --currentBit;
						 else throw new WMachineError("Error, out of bounds memory, index < 0");
						break;
					case "e" :
						if(_ruban[currentBit] == '1') _ruban[currentBit] = '0';
						break;
					default:
						if(isNumeric(_tokens[currentTok]))
							if(_ruban[currentBit] == '1' && to!int(_tokens[currentTok]) >= 0)
							{	
								currentTok = to!uint(_tokens[currentTok]);
								continue;
							}
							else break;
						else
							throw new WMachineError("Error, token : %s is invalid".format(_tokens[currentTok]));
						break;
				}
				++currentTok;
			}
		}
		@property string result()
		{
			return to!string(_ruban);
		}
		~this()
		{
			clear(_tokens);
			clear(_ruban);
		}
	}
}

unittest
{
	auto wmachine = new WMachine(10);
	try
	{
		wmachine.parse("* > > * 0");
		wmachine.process();
		writeln(wmachine.result);
		
		wmachine.parse("* > > * > * 0");
		wmachine.process();
		writeln(wmachine.result);
	}
	catch(WMachineError e)
	{
		writeln(e.msg);
	}
	finally
	{
		clear(wmachine);
	}
}