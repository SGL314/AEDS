class Organismo {
  PVector posicao;
  PVector velocidade;
  float[] dna;
  float vida; //Indica a aptidão (quanto mais saúde, melhor)
  float velocidadeMax;
  float percepcao; // Distância máxima para detectar recursos
  float tamanho;
  char sexo;
  int loop = 0;
  
  Organismo(PVector posicao, float[] dna) {
    this.posicao = posicao.copy();
    this.dna = dna;
    this.vida = 100;
    this.sexo = (random(1)>0.5) ? 'm' : 'f';
    
    // Fenótipo derivado do genótipo (DNA)
    this.velocidadeMax = map(dna[0], 0, 1, 2, 5);
    this.percepcao = map(dna[1], 0, 1, 50, 200);
    this.tamanho = map(dna[2], 0, 1, 4, 8);
    this.velocidade = PVector.random2D();
    
  }
  
  ArrayList<Organismo> atualiza() {
    this.loop++;
    // Movimento simples
    posicao.add(velocidade);
    // Consume energia ao se mover
    vida -= velocidadeMax/10.0;
    int distRep = (int) this.percepcao;
    int tetoLoop = 100;
    ArrayList<Organismo> adding = new ArrayList<>();

    for (Organismo org : populacao){
      try{
      if (org.posicao.dist(this.posicao) < distRep && this.loop > tetoLoop && org.loop > tetoLoop && org.sexo != this.sexo){
        this.loop = 0;
        org.loop = 0;
        adding.add(this.reproduzir(org));
      }
      } catch (Exception e){
        break;
      }
    }


    
    // Limites da tela
    if (posicao.x > width) posicao.x = 0;
    if (posicao.x < 0) posicao.x = width;
    if (posicao.y > height) posicao.y = 0;
    if (posicao.y < 0) posicao.y = height;

    return adding;
  }
  
  void procuraComida() {
    PVector maisProximo = null;
    float dist = Float.MAX_VALUE;
    
    for (PVector r : comida) {
      if (r == null) continue;
      float d = PVector.dist(posicao, r);
      if (d < dist && d < percepcao) {
        dist = d;
        maisProximo = r;
      }
    }
    
    if (maisProximo != null) {
      PVector desejado = PVector.sub(maisProximo, posicao);
      desejado.setMag(velocidadeMax);
      
      PVector direcao = PVector.sub(desejado, velocidade);
      velocidade.add(direcao);
      
      // Se reach o recurso, consome-o
      if (dist < tamanho) {
        vida += 75;
        comida.remove(maisProximo);
      }
    }
  }
  
  Organismo reproduzir(Organismo org) {
    // Reproduz com uma probabilidade baseada na saúde
    if (random(1) > 0 && vida > 25) {
      float[] novoDna = new float[3];
      arrayCopy(dna, novoDna);
      novoDna[1] = org.dna[1];
      
      // mutacao
      for(int k = 0; k < novoDna.length; k++)
        if(random(1) < 0.001) novoDna[k] = constrain(novoDna[k] + random(-0.1, 0.1), 0, 1);
      
      vida-=10;
      return new Organismo(posicao, novoDna);
    } else {
      return null;
    }
  }
  
  boolean morreu() {
    return vida <= 0;
  }
  
  void mostra() {
    stroke(0);
    colorMode(HSB, 360, 100, 100);
    fill(cor(map(velocidadeMax, 2, 5, 0, 100)));
    if (this.sexo == 'm') ellipse(posicao.x, posicao.y, tamanho, tamanho);
    else square(posicao.x, posicao.y, tamanho);
    colorMode(RGB, 255, 255, 255);
  }
  
  color cor(float valor) {
    valor = constrain(valor, 0, 100);
    float matiz = map(valor, 0, 100, 0, 120);
    return color(matiz, 100, 100);
  }
}
