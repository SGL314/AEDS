class Particula {
  PVector posicao;
  PVector velocidade;
  color cor;
  int duracaoVida;

  Particula(PVector posicao, PVector velocidade, color cor) {
    this.posicao = posicao;
    this.velocidade = velocidade;
    this.cor = cor;
    duracaoVida = int(random(255));
  }

  void atualizar() {
    posicao.add(velocidade);
    duracaoVida--;
    
    // Reflexao nas bordas
    if (posicao.x < 0 || posicao.x > width)  velocidade.x *= -1;
    if (posicao.y < 0 || posicao.y > height) velocidade.y *= -1;
    
  }

  void exibir() {
    fill(cor, duracaoVida);
    noStroke();
    ellipse(posicao.x, posicao.y, 50*duracaoVida/255, 50*duracaoVida/255);
  }
}
