package 
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.text.TextField;

	public class Game extends MovieClip
	{
		public var balls:Array;
		public var vx:Number;
		public var vy:Number;;
		private var LEFT:Number;
		private var RIGHT:Number;
		private var TOP:Number;
		private var BOTTOM:Number;
		private const MINSPEED = .1;
		private const FRICTION = .95;
		private const RADIUS = 10;
		private const SWITCH = -1;
		
		public function Game()
		{
			// constructor code
			
			
			LEFT = table.x + RADIUS;
			RIGHT = table.x + table.width - RADIUS;
			TOP = table.y + RADIUS;
			BOTTOM = table.y + table.height - RADIUS;
			//push all balls to an array
			balls = new Array();
			balls.push(cueBall);
			balls.push(ball1);
			balls.push(ball2);
			balls.push(ball3);
			balls.push(ball4);
			balls.push(ball5);
			balls.push(ball6);
			stick.addEventListener(Event.ENTER_FRAME,aimStick);
			stick.addEventListener(MouseEvent.MOUSE_DOWN,startToShoot);
			
			
			for(var i:uint = 0; i < balls.length; i++){
				balls[i].vx = 0;
				balls[i].vy = 0;
			}
			addEventListener(Event.ENTER_FRAME, moveBalls);
			
			
		}
		//Event Listeners will require aimStick() and startToShoot() handlers

		//**********************************************************************
		//  Function Name: aimStick
		//  An event handler that rotates the angle of the stick around the cueball.
		//**********************************************************************
		public function aimStick(event:Event)
		{	
			
			var dx:Number = cueBall.x - mouseX;
			var dy:Number = cueBall.y - mouseY;
			var angle:Number = Math.atan2(dy,dx);
			stick.rotation = angle * 180 / Math.PI;
			stick.x = mouseX;
			stick.y = mouseY;
			
		}

		//**********************************************************************
		//  Function Name: startToShoot
		//  An event handler that initializes a shoot.
		//**********************************************************************
		public function startToShoot(event:MouseEvent)
		{
			//TASK 1:  LOCATE THE DISTANCE BETWEEN THE STICK AND CUEBALL
			var dx:Number = cueBall.x - mouseX;
			var dy:Number = cueBall.y - mouseY;
			var dist:Number = Math.sqrt(dx * dx + dy * dy);

			//TASK 2:  IF WITHIN SHOOTING RANGE, WAIT FOR THE USER TO FINISH THE SHOOT
			if (dist > 110)
			{
				stick.startx = stick.x;//TO BE USED TO CALCULATE THE VELOCITY OF THE STICK
				stick.starty = stick.y;
				stick.addEventListener(Event.ENTER_FRAME,finishShoot);
				
				
			}
		}

		//**********************************************************************
		//  Function Name: finishShoot
		//  Event handler computes the velocity of the stick and appies it to the cueball.
		//**********************************************************************
		public function finishShoot(event:Event)
		{
			//TASK 1:  COMPUTE THE DISTANCE BETWEEN THE STICK AND THE CUEBALL
			var dx:Number = cueBall.x - stick.x;
			var dy:Number = cueBall.y - stick.y;
			var dist:Number = Math.sqrt(dx * dx + dy * dy);

			//CHECK IF THE STICK HAS JUST HIT THE CUEBALL
			if (dist < 110)
			{
				//TASK 2:  COMPUTE THE NEW VELOCITY OF THE CUEBALL
				cueBall.vx = (stick.x-stick.startx);
				cueBall.vy = (stick.y-stick.starty);
				
				//TASK 3:  THE FINISHSHOOT IS DONE
				stick.removeEventListener(Event.ENTER_FRAME,finishShoot);
				
			}
			
		}
		
		public function moveBalls(event: Event) {
			for (var i:uint; i < balls.length; i++){
				balls[i].vx *= FRICTION;
				balls[i].vy *= FRICTION;
				
				balls[i].x += balls[i].vx;
				balls[i].y += balls[i].vy;
				
				checkWallCollision(balls[i]);
				
				var speed:Number = Math.sqrt(balls[i].vx * balls[i].vx + balls[i].vy * balls[i].vy);
				if(speed <= MINSPEED){
					balls[i].vx = 0;
					balls[i].vy = 0;
				}
			}
			
			for(i = 0; i < balls.length; i++){
				for(var k:uint = i+1; k < balls.length; k++){
					checkCollision(balls[i], balls[k]);
				}
			}
			for(var j:uint = 0; j < balls.length; j++){
				if(Math.sqrt((balls[j].x - hole1.x)*(balls[j].x - hole1.x) + (balls[j].y - hole1.y)*(balls[j].y - hole1.y)) <= 14 ){
					balls[j].x = 0;
					balls[j].y = 0;
				}
				if(Math.sqrt((balls[j].x - hole2.x)*(balls[j].x - hole2.x) + (balls[j].y - hole2.y)*(balls[j].y - hole2.y)) <= 14 ){
					balls[j].x = 0;
					balls[j].y = 0;
				}
				if(Math.sqrt((balls[j].x - hole3.x)*(balls[j].x - hole3.x) + (balls[j].y - hole3.y)*(balls[j].y - hole3.y)) <= 14 ){
					balls[j].x = 0;
					balls[j].y = 0;
				}
				if(Math.sqrt((balls[j].x - hole4.x)*(balls[j].x - hole4.x) + (balls[j].y - hole4.y)*(balls[j].y - hole4.y)) <= 14 ){
					balls[j].x = 0;
					balls[j].y = 0;
				}
				if(Math.sqrt((balls[j].x - hole5.x)*(balls[j].x - hole5.x) + (balls[j].y - hole5.y)*(balls[j].y - hole5.y)) <= 14 ){
					balls[j].x = 0;
					balls[j].y = 0;
				}
				if(Math.sqrt((balls[j].x - hole6.x)*(balls[j].x - hole6.x) + (balls[j].y - hole6.y)*(balls[j].y - hole6.y)) <= 14 ){
					balls[j].x = 0;
					balls[j].y = 0;
				}
				if(cueBall.x == 0 || cueBall.y == 0){
						cueBall.x = 618.3;
						cueBall.y = 338.05;
						cueBall.vx = 0;
						cueBall.vy = 0;
				}
			}
		}
		
		public function checkCollision(ball1, ball2):void{
			//TASK 1: COMPUTE THE DISTANCE BETWEEN THE BALLS
			var dx:Number = ball1.x - ball2.x;
			var dy:Number = ball1.y - ball2.y;
			var dist:Number = Math.sqrt(dx*dx + dy*dy);
			
			//TASK 2: CHECK IF THERE IS A COLLISION
			if (dist < 20){
			var angle:Number = Math.atan2(dy, dx);
			var cos:Number = Math.cos(angle);
			var sin:Number = Math.sin(angle);
			
			//REPOSITION BALL 1 SO THAT IT DOESN'T OVERLAP
			ball1.x = ball2.x + cos*20;
			ball1.y = ball2.y + sin*20;
			
			
			//COMPUTE NEW VELOCITIES AT A ROTATED ANGLE
			var vx1:Number = cos*ball2.vx + sin*ball2.vy;
			var vy1:Number = cos*ball1.vy - sin*ball1.vx;
			var vx2:Number = cos*ball1.vx + sin*ball1.vy;
			var vy2:Number = cos*ball2.vy - sin*ball2.vx;
			
			//COMPUTE THE VELOCITIES FOR EACH BALL
			ball1.vx = cos*vx1 - sin*vy1;
			ball1.vy = cos*vy1 + sin*vx1;
			ball2.vx = cos*vx2 - sin*vy2;
			ball2.vy = cos*vy2 + sin*vx2;
			}
		}
		
		
		private function checkWallCollision(ball):void
			{
				if (ball.x < LEFT)
				{
					ball.x = LEFT;
					ball.vx *=  SWITCH;
				}
				else if (ball.x > RIGHT)
				{
					ball.x = RIGHT;
					ball.vx *=  SWITCH;
				}
			
				if (ball.y < TOP)
				{
					ball.y = TOP;
					ball.vy *=  SWITCH;
				}
				else if (ball.y > BOTTOM)
				{
					ball.y = BOTTOM;
					ball.vy *=  SWITCH;
					
				}
			
		}
		


	}
}