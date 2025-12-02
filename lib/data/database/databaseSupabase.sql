-- SE USA COMILLAS YA QUE ES UNA PALABRA RESERVADA
CREATE TABLE "user" (
    idUser SERIAL PRIMARY KEY,
    userUUID UUID UNIQUE NOT NULL,
    username TEXT NOT NULL UNIQUE, -- EL NOMBRE DEL USUARIO SERA UNICO Y DE LONGUITUD DE 12
  	mail TEXT NOT NULL UNIQUE, -- EL MAIL SERA UNICO
  	passwordHash TEXT NOT NULL,
  	creationDate TIMESTAMP  NOT NULL,
  	imageUrl TEXT NOT NULL /** nota: por defecto tendra una imagen predeterminada **/
);


CREATE TABLE cubeType (
  idCubeType SERIAL PRIMARY KEY,
  cubeName TEXT NOT NULL, -- EL NOMBRE DEL CUBO SERA UNICO
   -- CADA USUARIO TENDRA SUS TIPOS DE CUBOS
  idUser INTEGER NOT NULL REFERENCES "user"(idUser) ON DELETE CASCADE,
  -- ASEGURAR QUE UN USUARIO NO TENGA MAS DE UN TIPO DE CUBO CON EL MISMO NOMBRE
  UNIQUE (idUser, cubeName)
);

CREATE TABLE sessionTime (
	idSession serial PRIMARY KEY,
  idUser INTEGER NOT NULL REFERENCES "user"(idUser),
  sessionName TEXT NOT NULL,
  creationDate TIMESTAMP NOT NULL,
  idCubeType INTEGER NOT NULL REFERENCES cubeType(idCubeType),
  -- ASEGURAR QUE UN USUARIO NO PUEDA TENER DOS SESIONES CON EL MISMO NOMBRE DE DISTINTO TIPO DE CUBO
  UNIQUE (idUser, sessionName, idCubeType)
);

CREATE TABLE timeTraining (
	idTimeTraining SERIAL PRIMARY KEY,
  idSession INTEGER NOT NULL REFERENCES sessionTime(idSession),
  scramble TEXT NOT NULL,
  timeInSeconds REAL NOT NULL,
  comments TEXT DEFAULT NULL,
  -- RESTRINGIMOS LOS VALORES DEL CAMPO penalty (tipo ENUM)
  penalty TEXT CHECK(penalty IN ('none', 'DNF', '+2')) DEFAULT 'none',
  --  POR DEFECTO ES EL TIEMPO ACTUAL
  registrationDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE method (
  idMethod SERIAL PRIMARY KEY,
  methodName TEXT NOT NULL,
  -- NOMBRE DEL TIPO DE CUBO RELACIONADO AL METODO
  cubeTypeName TEXT NOT NULL
);

CREATE TABLE step (
  idStep SERIAL PRIMARY KEY,
  stepTitle TEXT NOT NULL,
  -- NUMERO DEL PASO
  stepNumber INTEGER NOT NULL,
  -- UN METODO TIENE MUCHOS PASOS
  idMethod INTEGER NOT NULL REFERENCES method(idMethod),
  -- SE ASEGURA UN ORDEN UNICO (ASI NO EXISTEN 2 PASOS 1 EN EL MISMO METODO)
  UNIQUE (idMethod, stepNumber)
);

CREATE TABLE stepContent (
  idStepContent SERIAL PRIMARY KEY,
  content TEXT,
  -- TIPO DE CONTENIDO DE WIDGET, POR SI ES UN TEXT, IMAGE, GRID
  type TEXT,
  -- JSON CON PARAMETROS DEL COMPONENTE
  data JSON,
  -- ORDEN EN EL QUE SE MUESTRAN LOS CONTENIDOS DENTRO DEL MISMO PASO
  -- PERMITIENDO VARIOS BLOQUES (TEXTO, LUEGO IMAGEN, LUEGO GRID, ETC)
  orderIndex INTEGER DEFAULT 0,
  -- CADA PASO TIENE MUCHOS CONTENIDOS
  idStep INTEGER NOT NULL REFERENCES step(idStep)
);


INSERT INTO method (methodName, cubeTypeName) VALUES ('beginner_method_name', '2x2x2');
INSERT INTO method (methodName, cubeTypeName) VALUES ('beginner_method_name', '4x4x4');
INSERT INTO method (methodName, cubeTypeName) VALUES ('beginner_method_name', '3x3x3');
INSERT INTO method (methodName, cubeTypeName) VALUES ('reduced_fridrich_method_name', '3x3x3');
INSERT INTO method (methodName, cubeTypeName) VALUES ('advanced_fridrich_method_name', '3x3x3');

INSERT INTO step (stepTitle, stepNumber, idMethod) VALUES (
  'cross_step_title', 1, (SELECT idMethod FROM method WHERE cubeTypeName = '3x3x3' AND methodName = 'beginner_method_name')
);
INSERT INTO step (stepTitle, stepNumber, idMethod) VALUES (
  'first_layer_step_title', 2, (SELECT idMethod FROM method WHERE cubeTypeName = '3x3x3' AND methodName = 'beginner_method_name')
);
INSERT INTO step (stepTitle, stepNumber, idMethod) VALUES (
  'second_layer_step_title', 3, (SELECT idMethod FROM method WHERE cubeTypeName = '3x3x3' AND methodName = 'beginner_method_name')
);
INSERT INTO step (stepTitle, stepNumber, idMethod) VALUES (
  'orient_last_layer_step_title', 4, (SELECT idMethod FROM method WHERE cubeTypeName = '3x3x3' AND methodName = 'beginner_method_name')
);
INSERT INTO step (stepTitle, stepNumber, idMethod) VALUES (
  'permute_last_layer_step_title', 5, (SELECT idMethod FROM method WHERE cubeTypeName = '3x3x3' AND methodName = 'beginner_method_name')
);
INSERT INTO step (stepTitle, stepNumber, idMethod) VALUES (
  'not_available', 1, (SELECT idMethod FROM method WHERE cubeTypeName = '2x2x2' AND methodName = 'beginner_method_name')
);
INSERT INTO step (stepTitle, stepNumber, idMethod) VALUES (
  'not_available', 1, (SELECT idMethod FROM method WHERE cubeTypeName = '4x4x4' AND methodName = 'beginner_method_name')
);
