--creacion de la base de datos
CREATE DATABASE "controlInventario"
  WITH OWNER = "Danny"
       ENCODING = 'UTF8'
       TABLESPACE = pg_default
       LC_COLLATE = 'Spanish_Ecuador.1252'
       LC_CTYPE = 'Spanish_Ecuador.1252'
       CONNECTION LIMIT = -1;
--creacion tabla personas
create sequence persona_sec;
CREATE TABLE personas
(
  "idPersona" integer NOT NULL default nextval('persona_sec'),
  nombre character varying(50) NOT NULL,
  direccion character varying(50) NOT NULL,
  telefono character varying(10) NOT NULL,
  CONSTRAINT personas_pkey PRIMARY KEY ("idPersona")
)
WITH (
  OIDS=FALSE
);
ALTER TABLE personas OWNER TO "Danny";
--crear tabla para personas juridicas
CREATE TABLE juridico
(
  "idPersona" integer NOT NULL,
  "RUC" character varying(13) NOT NULL,
  CONSTRAINT juridico_pkey PRIMARY KEY ("idPersona"),
  CONSTRAINT "juridico_idPersona_fkey" FOREIGN KEY ("idPersona")
      REFERENCES personas ("idPersona") MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE juridico OWNER TO "Danny";

ALTER TABLE juridico OWNER TO "Danny";
--crear tabla para personas naturales
CREATE TABLE "natural"
(
  "idPersona" integer NOT NULL,
  "numeroCedula" character varying(10) NOT NULL,
  CONSTRAINT natural_pkey PRIMARY KEY ("idPersona"),
  CONSTRAINT "natural_idPersona_fkey" FOREIGN KEY ("idPersona")
      REFERENCES personas ("idPersona") MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "natural" OWNER TO "Danny";

--creacion tabla proveedores
create sequence proveedores_sec;
CREATE TABLE proveedores
(
  "idProveedor" integer NOT NULL default nextval('proveedores_sec'),
  "idPersona" INTEGER NOT NULL,
  CONSTRAINT proveedores_pkey PRIMARY KEY ("idProveedor"),
  CONSTRAINT "proveedores_idPersona_fkey" FOREIGN KEY ("idPersona")
      REFERENCES proveedores ("idProveedor") MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE proveedores OWNER TO "Danny";
--crear tabla clientes
create sequence cliente_sec;
CREATE TABLE clientes
(
  "idCliente" INTEGER NOT NULL default nextval('cliente_sec'),
  "idPersona" INTEGER NOT NULL,
  CONSTRAINT clientes_pkey PRIMARY KEY ("idCliente"),
  CONSTRAINT "clientes_idPersona_fkey" FOREIGN KEY ("idPersona")
  REFERENCES clientes ("idCliente") MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE clientes OWNER TO "Danny";
--crear tabla empleados
create sequence empleado_sec;
CREATE TABLE empleados 
(
  "idEmpleado" INTEGER NOT NULL default nextval('empleado_sec'),
  "idPersona" INTEGER NOT NULL,
  CONSTRAINT empleado_pkey PRIMARY KEY ("idEmpleado"),
  CONSTRAINT "empleados_idPersona_fkey" FOREIGN KEY ("idPersona")
  REFERENCES empleados ("idEmpleado") MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
  )
  WITH (
    OIDS=FALSE
  );
  --crear tabla de bodega
  create sequence bodega_sec;
  CREATE TABLE bodegas
(
   "idBodega" integer NOT NULL default nextval('bodega_sec'), 
   nombre character varying(50) NOT NULL, 
   "idProducto" integer NOT NULL, 
    PRIMARY KEY ("idBodega"),
    CONSTRAINT "bodegas_idProducto_fkey" FOREIGN KEY ("idProducto")
       REFERENCES bodegas ("idBodega") MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
) 
WITH (
  OIDS = FALSE
)
;
ALTER TABLE bodegas OWNER TO "Danny";
--crear tabla producto
CREATE SEQUENCE producto_sec;
CREATE TABLE productos
(
   "idProducto" integer NOT NULL default nextval('producto_sec'), 
   nombre character varying(50) NOT NULL, 
   "fechaCaducidad" date NOT NULL, 
   cantidad integer NOT NULL, 
   precio money NOT NULL, 
   "idTipoProducto" integer NOT NULL, 
    PRIMARY KEY ("idProducto"),
    CONSTRAINT "productos_idTipoProducto_fkey" FOREIGN KEY ("idTipoProducto")
       REFERENCES productos ("idProducto") MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
) 
WITH (
  OIDS = FALSE
)
;
ALTER TABLE productos OWNER TO "Danny";
--crear tabla tipo de producto
create sequence tipoProducto_sec;
CREATE TABLE "tipoProducto"
(
  "idTipoProducto" integer NOT NULL default nextval('tipoProducto_sec'),
  "nombreProducto" character varying(50) NOT NULL,
  CONSTRAINT "tipoProducto_pkey" PRIMARY KEY ("idTipoProducto")
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "tipoProducto" OWNER TO "Danny";
--crear tabla producto por bodega
CREATE TABLE "productoPorBodega"
(
   "idProductoPorBodega" integer NOT NULL, 
   "idBodega" integer NOT NULL, 
   "idProducto" integer NOT NULL, 
   cantidad integer NOT NULL, 
    PRIMARY KEY ("idProductoPorBodega"), 
      CONSTRAINT "productoPorBodega_idBodega_fkey, productoPorBodega_idProducto_fkey" FOREIGN KEY ("idBodega", "idProducto")
       REFERENCES productoPorBodega ("idProductoPorBodega") MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
        
) 
WITH (
  OIDS = FALSE
)
;
ALTER TABLE "productoPorBodega" OWNER TO "Danny";
--crear tabla proveedor por producto
create SEQUENCE ppp_sec;
CREATE TABLE "proveedorPorProducto"
(
   "idPpp" integer NOT NULL default nextval('ppp_sec'), 
   "idProveedor" integer NOT NULL, 
   "idProducto" integer NOT NULL, 
    PRIMARY KEY ("idPpp"),
     CONSTRAINT "idProveedor" FOREIGN KEY ("idProveedor")
      REFERENCES "proveedorPorProducto" ("idPpp") MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
     CONSTRAINT "proveedorPorProducto_idProducto_fkey" FOREIGN KEY ("idProducto")
      REFERENCES "proveedorPorProducto" ("idPpp") MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
) 
WITH (
  OIDS = FALSE
)
;
ALTER TABLE "proveedorPorProducto" OWNER TO "Danny";
--crear tabla facturas 

CREATE TABLE facturas
(
  "idFactura" integer NOT NULL,
  "numeroFactura" integer NOT NULL,
  "fechaFactura" date NOT NULL,
  "idCliente" integer NOT NULL,
  "idEmpleado" integer NOT NULL,
  iva money NOT NULL,
  total money NOT NULL,
  CONSTRAINT facturas_pkey PRIMARY KEY ("idFactura"),
  CONSTRAINT "facturas_idCliente_fkey" FOREIGN KEY ("idCliente")
      REFERENCES facturas ("idFactura") MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "facturas_idEmpleado_fkey" FOREIGN KEY ("idEmpleado")
      REFERENCES facturas ("idFactura") MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE facturas OWNER TO "Danny";
--crear tablas detalle factura
CREATE TABLE "detalleFactura"
(
  "idDetalle" integer NOT NULL,
  "idProducto" integer NOT NULL,
  "idFactura" integer NOT NULL,
  precio money NOT NULL,
  cantidad integer NOT NULL,
  "valorTotal" money NOT NULL,
  CONSTRAINT "detalleFactura_pkey" PRIMARY KEY ("idDetalle"),
  CONSTRAINT "detalleFactura_idFactura_fkey" FOREIGN KEY ("idFactura")
      REFERENCES "detalleFactura" ("idDetalle") MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "detalleFactura_idProducto_fkey" FOREIGN KEY ("idProducto")
      REFERENCES "detalleFactura" ("idDetalle") MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "detalleFactura" OWNER TO "Danny";

