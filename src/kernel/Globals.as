package kernel 
{
	/**
	 * ...
	 * @author Barnaby Byrne
	 */
	public class Globals 
	{		
		static public const DIALOGUE_OVERLAY_Y		:int = 325;
		//----------------------------------------------------------------------------------------
		// TILE TYPES
		
		static public const TILETYPE_VOID			:int = 0;
		static public const TILETYPE_SOLID			:int = 1;
		static public const TILETYPE_LADDER			:int = 2;
		static public const TILETYPE_JUMPTHROUGH	:int = 3;
		static public const TILETYPE_PLAYERSTART	:int = 4;
		
		//----------------------------------------------------------------------------------------
		// OBJECT TYPES
	
		static public var OBJTYPE_PLAYER			:int = 0;
		static public var OBJTYPE_PLAYERBULLET		:int = 1;
		static public var OBJTYPE_ENEMYBULLET		:int = 2;
		static public var OBJTYPE_COIN				:int = 3;
		static public var OBJTYPE_GHOST				:int = 4;
		static public var OBJTYPE_PARTICLE			:int = 5;
		static public var OBJTYPE_CHECKPOINT		:int = 6;
		static public var OBJTYPE_INFOPOINT			:int = 7;
		static public var OBJTYPE_EXIT				:int = 8;
		static public var OBJTYPE_WAYPOINT			:int = 9;
		static public var OBJTYPE_LAVA				:int = 10;
		static public var OBJTYPE_PLAYERGRENADE		:int = 11;
		static public var OBJTYPE_SAUCER			:int = 12;
		static public var OBJTYPE_TURRET			:int = 13;
		static public var OBJTYPE_KEYCARD			:int = 14;
		static public var OBJTYPE_HEART				:int = 15;
		static public var OBJTYPE_SNAKE				:int = 16;
		static public var OBJTYPE_SOLDIER			:int = 17;
		static public var OBJTYPE_SPIKE				:int = 18;
		static public var OBJTYPE_SCORE				:int = 19;
		static public var OBJTYPE_SOLDIERBULLET		:int = 20;
		static public var OBJTYPE_TURRETBULLET		:int = 21;
		static public var OBJTYPE_EXPLOSION			:int = 22;
		static public var OBJTYPE_FLASHINGBLOCK		:int = 23;
		static public var OBJTYPE_NANOSHOES			:int = 24;
		static public var OBJTYPE_PARTICLEBEAM		:int = 25;
		static public var OBJTYPE_SPAWNER			:int = 26;
		static public var OBJTYPE_SLOPE				:int = 27;
		static public var OBJTYPE_CLOUD				:int = 28;
		static public var OBJTYPE_SCOREBREAKDOWN	:int = 29;
		
		//----------------------------------------------------------------------------------------
		// MAX NO OF OBJECTS FOR OBJECT POOLS

		static public var MAX_PLAYER_BULLETS		:int = 50;		
		static public var MAX_COINS					:int = 50;		
		static public var MAX_ENEMYS				:int = 20;		
		static public var MAX_PARTICLES				:int = 500;		
		static public var MAX_CHECKPOINTS			:int = 5;		
		static public var MAX_INFOPOINTS			:int = 15;		
		static public var MAX_WAYPOINTS				:int = 50;		
		static public var MAX_LAVABLOCKS			:int = 50;		
		static public var MAX_PLAYER_GRENADES		:int = 10;		
		static public var MAX_ENEMY_BULLETS			:int = 20;		
		static public var MAX_HEARTS				:int = 5;		
		static public var MAX_SCORES				:int = 5;		
		static public var MAX_TURRETS				:int = 20;		
		static public var MAX_SPIKES				:int = 20;		
		static public var MAX_EXPLOSIONS			:int = 50;		
	
		//----------------------------------------------------------------------------------------
		// DIRECTIONS
	
		static public var FACING_LEFT				:int = 0;
		static public var FACING_RIGHT				:int = 1;
		static public var FACING_LEFT_WALKINGBACK	:int = 2;
		static public var FACING_RIGHT_WALKINGBACK	:int = 3;
		static public var STATIC					:int = 4;
		static public var FACING_UP					:int = 5;
		static public var FACING_DOWN				:int = 6;
		
		//----------------------------------------------------------------------------------------
		// SCREEN SIZE
	
		//static public var SCREEN_SCALE			:int = 1;
		static public var TILE_SIZE					:int = 40;
		static public var SCREEN_WIDTH				:int = 825;
		static public var SCREEN_HEIGHT				:int = 490;		

		//----------------------------------------------------------------------------------------
		// KEYS
	
		static public var KEYUP						:int = 38; // up arrow = x
		static public var KEYUP2					:int = 67; // alternative up arrow = c
		//static public var KEYX					:int = 88; // x key
		static public var KEYDOWN					:int = 40; // down arrow
		static public var KEYDOWN2					:int = 75; // down arrow 2 = k
		static public var KEYLEFT					:int = 37; // left arrow
		static public var KEYLEFT2					:int = 74; // left arrow 2 = j
		static public var KEYRIGHT					:int = 39; // right arrow
		static public var KEYRIGHT2					:int = 76; // right arrow 2 = l
		static public var KEYRESTART				:int = 82; // r
		//static public var KEYGUN					:int = 65; // a
		//static public var KEYRUN					:int = 83; // s		
		static public var KEYGUN					:int = 88; // x
		//static public var KEYRUN					:int = 88; // x
		//static public var KEYGRENADE				:int = 83; // s
		static public var KEYGUNUP					:int = 68; // d
		static public var KEY1						:int = 49; 	
		static public var KEY2						:int = 50; 	
		static public var KEY3						:int = 51; 	
		static public var KEY4						:int = 52; 	
		static public var PAUSE						:int = 80; 	
		static public var KEYQUIT					:int = 27; 	
		static public var KEYMUTE					:int = 77; 	
		
		
		// a = 65  s = 83  d = 68
				
		
		// KEYCODES			
				
		/*

		Backspace = 8

		Tab = 9

		Enter = 13

		Shift = 16

		Control = 17

		CapsLock = 20

		Esc = 27

		Spacebar = 32

		PageUp = 33

		PageDown = 34

		End = 35

		Home = 36

		LeftArrow = 37

		UpArrow = 38

		RightArrow = 39

		DownArrow = 40

		Insert = 45

		Delete = 46

		NumLock = 144

		ScrLk = 145

		Pause/Break = 19

		A = 65

		B = 66

		C = 67

		D = 68
		 
		E = 69

		F = 70

		G = 71

		H = 72

		I = 73

		J = 74

		K = 75

		L = 76

		M = 77

		N = 78

		O = 79

		P = 80

		Q = 81

		R = 82

		S = 83

		T = 84

		U = 85

		V = 86

		W = 87

		X = 88

		Y = 89

		Z = 90

		a = 65

		b = 66

		c = 67
		 
		d = 68

		e = 69

		f = 70

		g = 71

		h = 72

		i = 73

		j = 74

		k = 75

		l = 76

		m = 77

		n = 78

		o = 79

		p = 80

		q = 81

		r = 82

		s = 83

		t = 84

		u = 85

		v = 86

		w = 87

		x = 88

		y = 89

		z = 90

		0 = 48

		1 = 49

		2 = 50

		3 = 51

		4 = 52

		5 = 53

		6 = 54

		7 = 55

		8 = 56

		9 = 57

		;: = 186

		=+ = 187

		-_ = 189

		/? = 191

		`~ = 192

		[{ = 219

		\| = 220

		]} = 221

		"' = 222

		, = 188

		. = 190

		/ = 191

		Numpad 0 = 96

		Numpad 1 = 97

		Numpad 2 = 98

		Numpad 3 = 99

		Numpad 4 = 100
		 
		Numpad 5 = 101

		Numpad 6 = 102

		Numpad 7 = 103

		Numpad 8 = 104

		Numpad 9 = 105

		Numpad Multiply = 106

		Numpad Add = 107

		Numpad Enter = 13

		Numpad Subtract = 109

		Numpad Decimal = 110

		Numpad Divide = 111

		F1 = 112

		F2 = 113

		F3 = 114

		F4 = 115

		F5 = 116

		F6 = 117

		F7 = 118

		F8 = 119

		F9 = 120

		F10 = nokey

		F11 = 122

		F12 = 123

		F13 = 124

		F14 = 125

		F15 = 126
		 
		*/

		public function Globals() 
		{
			
		}
		
	}
}