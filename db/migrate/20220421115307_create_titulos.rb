class CreateTitulos < ActiveRecord::Migration[6.1]
  def change
    create_table :titulos do |t|
      t.decimal :cnpj_cedente
      t.decimal :cnpj_sacado
      t.text :numero_titulo
      t.float :valor
      t.date :data_vencimento
      t.date :data_importacao
    end
  end
end
