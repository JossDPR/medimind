class Api::OpenaiController < ApplicationController
  require 'json'

  def call(question, img1_url, img2_url)
    create_content(question, img1_url, img2_url)
  end

  private

  def create_content(question, img1_url, img2_url)
    content = [
      {"type": "text", "text": question},
      {
        "type": "image_url",
        "image_url": {
          "url": img1_url,
        },
      }
    ]

    raise
    content.add()
  end

  def call_openai
    client = OpenAI::Client.new
    openai_response = client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: [
          {
            "role": "user",
            "content": [],
          }
        ]
      }
    )

  end

  def openai_compare_photo
    client = OpenAI::Client.new

    chatgpt_response = client.chat(
      parameters: {
        model: "gpt-4o-mini",
        max_tokens: 300,
        messages: [
                    {
                      "role": "user",
                      "content": [
                        {"type": "text", "text": "tu peux me dire si ce sont les mêmes noms de médicaments, les mêmes posologies, en répondant juste oui ou non dans reponse et les differences dans diffs?"},
                        {
                          "type": "image_url",
                          "image_url": {
                            "url": "https://www.pharma-medicaments.com/wp-content/uploads/2022/01/3595583-768x509.jpg",
                          },
                        },
                        {
                          "type": "image_url",
                          "image_url": {
                            "url": "https://images.lasante.net/2056-141093-large.webp",
                          },
                        },
                      ],
                    }
                  ]
      }
    )
    @content = chatgpt_response["choices"][0]["message"]["content"]
    raise
  end

  def openai_read_ordo
    client = OpenAI::Client.new

    chatgpt_response = client.chat(
      parameters: {
        model: "gpt-4o-mini",
        max_tokens: 300,
        messages: [
                    {
                      "role": "user",
                      "content": [
                        {"type": "text", "text": "tu peux me donner au format json la liste des medicaments de l'ordonance en séparent le nom du medicament, la posologie, le type de posologie exemple comprimé, gélule , le moment de la prise et la durée du traitement qu'il y a sur la photo sans rien ajouter devant le json?"},
                        {
                          "type": "image_url",
                          "image_url": {
                            "url": "https://static.allodocteurs.fr/btf-11-31157-default-660/b48bfa025a4c2f0951ceb2481b8f0e1b/media.jpg",
                          },
                        },
                      ],
                    }
                  ]
      }
    )
    @content = chatgpt_response["choices"][0]["message"]["content"]
    json_string = @content.gsub(/```json|```/, '').strip
    puts json_string
    json_hash = JSON.parse(json_string)

      raise
  end

  def openai_read_photo
    client = OpenAI::Client.new

    chatgpt_response = client.chat(
      parameters: {
        model: "gpt-4o-mini",
        max_tokens: 300,
        messages: [
                    {
                      "role": "user",
                      "content": [
                        {"type": "text", "text": "tu peux me donner au format json le nom du médiacament en tant que name, le dosage en tant que dosage, le type de cachet en tant que type et la description du medicament en tant que description qu'il y a sur la photo sans rien ajouter devant le json?"},
                        {
                          "type": "image_url",
                          "image_url": {
                            "url": "https://www.pharma-medicaments.com/wp-content/uploads/2022/01/3595583-768x509.jpg",
                          },
                        },
                      ],
                    }
                  ]
      }
    )
    @content = chatgpt_response["choices"][0]["message"]["content"]

    json_string = @content.gsub(/```json|```/, '').strip
    puts json_string
    json_hash = JSON.parse(json_string)

    medic = Medication.new
    medic.name = json_hash['name'] + " " + json_hash['dosage']
    medic.description = json_hash['description']

    verif_medic = Medication.where(name: medic.name)

    if (!verif_medic)
      medic.save!
      return medic
    else
      return verif_medic
    end

  end

end
