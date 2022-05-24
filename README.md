# Desafio final Dart
O desafio consiste em popular duas tabelas no banco de dados MySQL com os dados dos estados e cidades do Brasil consumindos da **API do IBGE**.

**Coleta informações do estado:**
```
https://servicodados.ibge.gov.br/api/v1/localidades/estados
```

**Coleta as cidades conforme o código do estado;**
```
https://servicodados.ibge.gov.br/api/v1/localidades/estados/ID_ESTADO/distritos'
```

**Script de criação das tabelas:**
```sql
CREATE TABLE estado (
  id int not null primary key auto_increment,
  uf varchar(2),
  nome varchar(255)
);

CREATE TABLE cidade (
  id int not null primary key auto_increment,
  id_uf int,
  nome varchar(255),
   FOREIGN KEY (id_uf)
      REFERENCES estado(id)
);​
```

`Edite o arquivo database.dart com as informações do seu banco de dados MySQL.`