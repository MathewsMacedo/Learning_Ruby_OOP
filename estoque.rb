require_relative 'Contador'

class Estoque

	def initialize

		@livros = []
		@vendas = []
		@livros.extend Contador

	end



def method_missing(name)

	tipo = 'livro|ebook|revista'
      matcher = name.to_s.match "(#{tipo})_que_mais_vendeu_por_(.+)"

      if matcher 
         tipo = matcher[1]
         campo = matcher[2].to_sym  #pois precisamos converter para simbolo
         que_mais_vendeu_por(tipo, &campo)
      else
         super
      end 
   end


   def respond_to?(name)
	 matched = name.to_s.match("(.+)_que_mais_vendeu_por_(.+)")
      !!matched || super
   end


	def << (livro)
		@livros << livro if livro
	end

	def vende (livro)
		@vendas << livro
		@livros.delete livro
	end

	def maximo_necessario
		@livros.maximo_necessario
	end


	def total
		@livros.size
	end


	def mais_barato_que(valor)
  
		@livros.select do |livro| 
			livro.preco < valor
		end

	end

	def exporta_csv

		@livros.each do |livro|
			livro.to_csv
		end
	end



	private
   def quantidade_de_vendas_por(produto, &campo)
    @vendas.count { |venda| campo.call(venda) == campo.call(produto) }
   end

   def que_mais_vendeu_por(tipo, &campo)
    @vendas.select {|produto| produto.matches?(tipo)}.sort {|v1,v2|
    quantidade_de_vendas_por(v1, &campo) <=> quantidade_de_vendas_por(v2, &campo)}.last
end



end