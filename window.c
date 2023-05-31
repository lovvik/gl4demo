#include "cave.h"




void init(void);

void draw_simple(void);
void draw_with_tex (void);
void draw_scene(void);

void idle(void);
void proc_keys(int keycode);

void clean(void);

unsigned int Sig = 0;

//int wW = 600, wH = 400;
int wW = 0, wH = 0;


unsigned int inUseIndex = 0;

GLuint skull=0, hand = 0, screen = 0;

GLuint _tex[2] = {0};

float send_time=0., bottle=.0;

Mix_Music* song = NULL;

GLuint _plan_ [8] = {0};





int main(int argc, char ** argv){

  SDL_Init(SDL_INIT_VIDEO);
  SDL_Init(SDL_INIT_AUDIO);


  SDL_DisplayMode display;
  if (SDL_GetCurrentDisplayMode(0, &display)<0){
    printf("Couldn't get resolution\n");
    return 1;
  };
  wW = display.w, wH = display.h;


  if(!gl4duwCreateWindow(argc, argv, "demo", GL4DW_POS_CENTERED, GL4DW_POS_CENTERED,
  wW, wH, GL4DW_OPENGL | GL4DW_FULLSCREEN_DESKTOP)){
    printf("couldn't open window\n");
    return 1;
  }

  SDL_GL_SetSwapInterval(1);


  init();
  atexit(clean);

  gl4duwIdleFunc(idle);
  gl4duwKeyDownFunc(proc_keys);




  gl4duwMainLoop();

  return 0;
}



void draw_scene(void){
  static float a = 0.;
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

 static float factor = 1.;

  GLuint back = _plan_[4], front = _plan_[5];

  glUseProgram(back);
  glUniform2f(glGetUniformLocation(back, "u_resolution"), (float)wW, (float)wH);
  glUniform1f(glGetUniformLocation(back, "u_time"),  send_time);
  gl4duBindMatrix("view");
  gl4duLoadIdentityf();
  gl4duBindMatrix("model");
  gl4duLoadIdentityf();
  gl4duScalef(1.1, 1.1, 1.);
  gl4duTranslatef(0,0,1.);
  gl4duSendMatrices();
  gl4dgDraw(screen);



  glUseProgram(front);
  glUniform2f(glGetUniformLocation(front, "u_resolution"), (float)wW, (float)wH);
  glUniform1f(glGetUniformLocation(front, "u_time"), send_time);



  gl4duBindMatrix("view");
  gl4duLoadIdentityf();
  //gl4duLookAtf(1, 0 , .0, x, .0, .0, .0, 1, .0);
  //gl4duTranslatef(.0, .0, x);
  gl4duRotatef(a, 0., 1., 0.);
  gl4duSendMatrices();




  gl4duBindMatrix("model");
  gl4duLoadIdentityf();

  float s = 0.4;
  s*=factor;
  gl4duScalef(s, s, s);

  gl4duRotatef(90, 0, 0, 1);
  gl4duRotatef(90, 1, 0, 0);
  gl4duRotatef(90, 0, 1, 0);
  gl4duRotatef(a, 1, 1, 1);
  gl4duSendMatrices();
  assimpDrawScene(skull);




  gl4duBindMatrix("model");
  gl4duLoadIdentityf();
  s = .8;
  s*=factor;
  gl4duScalef(s,s,s);
  gl4duRotatef(-90, 1, 0, 0);
  gl4duTranslatef(.0, -.10, -.45);
  gl4duSendMatrices();
  assimpDrawScene(hand);


  glUseProgram(0);
  a+=.8;
  if (Sig!=0) factor+=.08999;
};


void draw_with_tex(void){
  static int tex_index = 0;
  if(inUseIndex==6) tex_index = 0;
  else if(inUseIndex==7) tex_index=1;
  GLuint ProgId = _plan_[inUseIndex];
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

  //static float factor = 1.;


  glUseProgram(ProgId);
  glUniform2f(glGetUniformLocation(ProgId, "u_resolution"), (float)wW, (float)wH);
  glUniform1f(glGetUniformLocation(ProgId, "u_time"),  send_time);

  gl4duBindMatrix("view");
  gl4duLoadIdentityf();
  gl4duBindMatrix("model");
  gl4duLoadIdentityf();
  gl4duScalef(1.1, 1.1, 1.);
  gl4duTranslatef(0,0,1.);
  gl4duSendMatrices();

  glBindTexture(GL_TEXTURE_2D, _tex[tex_index]);
  gl4dgDraw(screen);

  glUseProgram(0);
}


void draw_simple(void){
  GLuint ProgId = _plan_[inUseIndex];
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

  //static float factor = 1.;


  glUseProgram(ProgId);
  glUniform2f(glGetUniformLocation(ProgId, "u_resolution"), (float)wW, (float)wH);
  glUniform1f(glGetUniformLocation(ProgId, "u_time"),  send_time);

  gl4duBindMatrix("view");
  gl4duLoadIdentityf();
  gl4duBindMatrix("model");
  gl4duLoadIdentityf();
  gl4duScalef(1.1, 1.1, 1.);
  gl4duTranslatef(0,0,1.);
  gl4duSendMatrices();

  gl4dgDraw(screen);

  glUseProgram(0);
}




void init(void){

  float c = .002;
  glClearColor(c, c, c, 1.0);

  skull = assimpGenScene("models/sphere_and_rotated_rings/scene.gltf");
  hand = assimpGenScene("models/hand/mannequin-hand-001.obj");
  screen = gl4dgGenQuadf();
  glGenTextures(sizeof _tex / sizeof *_tex, _tex); 
  loadTexture(_tex[0], "img/new.jpg");
  loadTexture(_tex[1], "img/credits.jpg");





  _plan_[0] = gl4duCreateProgram("<vs>shaders/vrtxshader.vs","<fs>shaders/lines.glsl", NULL);
  _plan_[1] = gl4duCreateProgram("<vs>shaders/vrtxshader.vs","<fs>shaders/circles.glsl", NULL);
  _plan_[2] = gl4duCreateProgram("<vs>shaders/vrtxshader.vs","<fs>shaders/warp.glsl", NULL);
  _plan_[3] = gl4duCreateProgram("<vs>shaders/vrtxshader.vs","<fs>shaders/orb.glsl", NULL);
  _plan_[4] = gl4duCreateProgram("<vs>shaders/vrtxshader.vs","<fs>shaders/screen.glsl", NULL);
  _plan_[5] = gl4duCreateProgram("<vs>shaders/vrtxshader.vs","<fs>shaders/stars.glsl", NULL);
  _plan_[6] = gl4duCreateProgram("<vs>shaders/vrtxshader.vs","<fs>shaders/blkhole.glsl", NULL);
  _plan_[7] = gl4duCreateProgram("<vs>shaders/vrtxshader.vs","<fs>shaders/credits.glsl", NULL);


  gl4duGenMatrix(GL_FLOAT, "view");
  gl4duBindMatrix("view");
  gl4duLoadIdentityf();

  gl4duGenMatrix(GL_FLOAT, "model");
  gl4duBindMatrix("model");
  gl4duLoadIdentityf();

  gl4duGenMatrix(GL_FLOAT, "proj");
  gl4duBindMatrix("proj");
  gl4duLoadIdentityf();

  gl4duBindMatrix("model");
  //gl4duFrustumf(-1.f, 1.f, -1.f, 1.f, -1.f, 1.f);


  gl4dInitTime0();
  gl4dInitTime();

  Mix_Init(MIX_INIT_MP3 | MIX_INIT_OGG);
  Mix_OpenAudio(44100, MIX_DEFAULT_FORMAT, 2, 2048);
  song = Mix_LoadMUS("music/frenshwipp.mp3");
  Mix_PlayMusic(song, 0);


};



void clean(void){

  Mix_FreeMusic(song);
  Mix_CloseAudio();
  Mix_Quit();

  ahClean();
  gl4duClean(GL4DU_ALL);
  SDL_Quit();

};


void proc_keys(int keycode){

  switch (keycode)
  {
  case GL4DK_ESCAPE:
    exit(0);
    break;
  
  default:
    break;
  }
};

void idle(void){
  send_time = gl4dGetTime()/1000.;
  bottle = gl4dGetElapsedTime()/1000.;

  if(bottle<20.) {inUseIndex= 0;}
  else if (bottle<40.) {inUseIndex= 1; }
  else if (bottle<60.) {inUseIndex= 2; }
  else if (bottle<80.) {inUseIndex= 3; }
  else if (bottle<118.) {
    if(bottle>108.) {
      Sig=1;
    }
    inUseIndex= 4;
  }
  else if (bottle<156.) {inUseIndex= 5; }
  else if (bottle<194.) {inUseIndex= 6; }
  else inUseIndex = 7;



  switch (inUseIndex)
  {
  case 4:
    gl4duwDisplayFunc(draw_scene);
    break;
  
  case 6 :
  case 7 :
    gl4duwDisplayFunc(draw_with_tex);
    break;

  default:
    gl4duwDisplayFunc(draw_simple);
    break;
  }

}
