require "prawn/measurement_extensions"

class PdfController < ApplicationController
  def index

    json = {"pdf_size":{"height":120,"width":170},"product_size":{"height":100,"width":150,"position":[10,110],"bg_color":"","shape":"rectangle"},"fix_stroke":"rgb(255,0,0)","text":[],"svg":[{"height":78.61635220125785,"width":78.61635220125785,"at":[37.42138364779874,13.836477987421382],"orientation":"","source":"<svg id='GRAVOSIGN_PICTO_4' data-name='Calque 1' xmlns='http://www.w3.org/2000/svg' viewBox='0 0 425.2 425.2'><polygon class='color-svg svg-bank-4' points='340.06 212.62 127.59 347.9 127.59 68.91 126.99 67.71 340.06 212.62' style='fill: rgb(255, 46, 210);'></polygon></svg>","color":"rgb(255, 46, 210)"}]}

    #pdf_size :
    pdf = Prawn::Document.new(
      page_size: [json[:pdf_size][:width].mm, json[:pdf_size][:height].mm],
      margin: 0
    )

    #product_size & shape & color :
    pdf.stroke_color "D40017"
    pdfBgColor = Prawn::Graphics::Color.rgb2hex(json[:product_size][:bg_color].gsub('rgb(', '').gsub(')', '').split(', '))
    if pdfBgColor != ""
      pdf.fill_color pdfBgColor
    else
      pdf.fill_color 'ffffff'
    end

    if json[:product_size][:shape] == "rounded-rectangle"
      pdf.fill_and_stroke_rounded_rectangle [json[:product_size][:position][0].mm, json[:product_size][:position][1].mm], json[:product_size][:width].mm, json[:product_size][:height].mm, 10.mm
    elsif json[:product_size][:shape] == "circle"
      pdf.fill_and_stroke_ellipse [(json[:pdf_size][:width].mm / 2), (json[:pdf_size][:height].mm / 2)], (json[:product_size][:width].mm / 2), (json[:product_size][:height].mm / 2)
    else
      pdf.fill_and_stroke_rectangle [json[:product_size][:position][0].mm, json[:product_size][:position][1].mm], json[:product_size][:width].mm, json[:product_size][:height].mm
    end

    #product_fix :
    if json[:product_fix]
      json[:product_fix].each do |fix|
        pdf.stroke_color "D40017"
        pdf.stroke_circle [fix[:x].mm, fix[:y].mm], fix[:diam].mm
      end
    end

    # Fonts :
    pdf.font_families.update(
      "Allerta" => {
        normal: Rails.root.join("app/assets/fonts/AllertaStencil-Regular.ttf")
      },
      "Domine" => {
        normal: Rails.root.join("app/assets/fonts/Domine-Regular.ttf"),
        bold: Rails.root.join("app/assets/fonts/Domine-Bold.ttf")
      },
      "KaushanScript" => {
        normal: Rails.root.join("app/assets/fonts/KaushanScript-Regular.ttf")
      },
      "Lato" => {
        normal: Rails.root.join("app/assets/fonts/Lato-Regular.ttf"),
        bold: Rails.root.join("app/assets/fonts/Lato-Bold.ttf")
      },
      "Muli" => {
        normal: Rails.root.join("app/assets/fonts/Muli-Regular.ttf"),
        bold: Rails.root.join("app/assets/fonts/Muli-Bold.ttf")
      },
      "OpenSans" => {
        normal: Rails.root.join("app/assets/fonts/OpenSans-Regular.ttf"),
        bold: Rails.root.join("app/assets/fonts/OpenSans-Bold.ttf")
      },
      "Orbitron" => {
        normal: Rails.root.join("app/assets/fonts/Orbitron-Regular.ttf"),
        bold: Rails.root.join("app/assets/fonts/Orbitron-Bold.ttf")
      },
      "Oswald" => {
        normal: Rails.root.join("app/assets/fonts/Oswald-Medium.ttf"),
        bold: Rails.root.join("app/assets/fonts/Oswald-Bold.ttf")
      },
      "PatrickHand" => {
        normal: Rails.root.join("app/assets/fonts/PatrickHand-Regular.ttf")
      },
      "Quicksand" => {
        normal: Rails.root.join("app/assets/fonts/Quicksand-Regular.ttf"),
        bold: Rails.root.join("app/assets/fonts/Quicksand-Bold.ttf")
      },
      "Satisfy" => {
        normal: Rails.root.join("app/assets/fonts/Satisfy-Regular.ttf")
      },
      "Tinos" => {
        normal: Rails.root.join("app/assets/fonts/Tinos-Regular.ttf"),
        bold: Rails.root.join("app/assets/fonts/Tinos-Bold.ttf"),
      },
      "TitilliumWeb" => {
        normal: Rails.root.join("app/assets/fonts/TitilliumWeb-Regular.ttf"),
        bold: Rails.root.join("app/assets/fonts/TitilliumWeb-Bold.ttf"),
      },
    )

    #text :
    if json[:text]
      json[:text].each do |text_element|
        pdftextColor = Prawn::Graphics::Color.rgb2hex(text_element[:text_color].gsub('rgb(', '').gsub(')', '').split(', '))
        if pdftextColor != ""
          pdf.fill_color pdftextColor
        else
          pdf.fill_color '000000'
        end
        pdf.font_size text_element[:font_size].mm
        pdf.font text_element[:font_family]
        if text_element[:text_align] == 'left'
          pdf.text_box text_element[:content], at: [(text_element[:at][0].mm + 10.mm), ((json[:product_size][:height].mm - text_element[:at][1].mm + 10.mm) - (0.4 * text_element[:font_size].mm))],
                                               width: text_element[:width].mm,
                                               height: text_element[:height].mm,
                                               align: :left,
                                               leading: 7,
                                               overflow: :expand
        elsif text_element[:text_align] == 'center'
          pdf.text_box text_element[:content], at: [(text_element[:at][0].mm + 10.mm), ((json[:product_size][:height].mm - text_element[:at][1].mm + 10.mm) - (0.4 * text_element[:font_size].mm))],
                                               width: text_element[:width].mm,
                                               height: text_element[:height].mm,
                                               align: :center,
                                               leading: 7,
                                               overflow: :expand
        elsif text_element[:text_align] == 'right'
          pdf.text_box text_element[:content], at: [(text_element[:at][0].mm + 10.mm), ((json[:product_size][:height].mm - text_element[:at][1].mm + 10.mm) - (0.4 * text_element[:font_size].mm))],
                                               width: text_element[:width].mm,
                                               height: text_element[:height].mm,
                                               align: :right,
                                               leading: 7,
                                               overflow: :expand
        end
      end
    end

    #svg :
    if json[:svg]
      json[:svg].each do |svg_element|
        pdf.rotate(svg_element[:orientation].to_i, origin: [(svg_element[:at][0].mm + (svg_element[:width].mm / 2) + 10.mm), (json[:product_size][:height].mm - svg_element[:at][1].mm - (svg_element[:width].mm / 2) + 10.mm)] ) do
          pdf.bounding_box([(svg_element[:at][0].mm + 10.mm), (json[:product_size][:height].mm - svg_element[:at][1].mm + 10.mm)], width: svg_element[:width].mm, height: svg_element[:height].mm) do
            pdf.svg svg_element[:source]
          end
        end
      end
    end

    #images :
    if json[:images]
      json[:images].each do |image_element|
        image = 'https://i.ytimg.com/vi/rQZ4eOONfIw/hqdefault.jpg'
        pdf.image image, at: [image_element[:at][0].mm + 10.mm, image_element[:at][1].mm + 10.mm], width: image_element[:width].mm
      end
    end


    #pdf_save :
    send_data pdf.render,
      filename: "export.pdf",
      type: 'application/pdf',
      disposition: 'inline'
  end

  def show
    @pdf = Pdf.find(params[:id])
    json = JSON.parse(@pdf.json).deep_symbolize_keys

    # construction du pdf

    # json = {"pdf_size":{"height":120,"width":170},"product_size":{"height":100,"width":150,"position":[10,110],"bg_color":"","shape":"rectangle"},"fix_stroke":"rgb(255,0,0)","text":[{"height":31.446540880503143,"width":150,"at":[0,23.270440251572325],"text_align":"center","font_size":5.660377358490566,"font_family":"OpenSans","content":"Votre texte ici"}],"svg":[{"height":78.61635220125785,"width":78.61635220125785,"at":[71.38364779874213,20.12578616352201],"orientation":"270","source":"<svg id='GRAVOSIGN_PICTO_12' data-name='Calque 1' xmlns='http://www.w3.org/2000/svg' viewBox='0 0 425.2 425.2'><path class='color-svg' d='M266.21,216.33l.33,1.23a10.57,10.57,0,0,1,.09,3.82A12,12,0,0,1,256,231a12.54,12.54,0,0,1-12.79-6.68,5.76,5.76,0,0,1-.28-.68q-.66-2-1.25-4l-23-79.11-.78-1a4.07,4.07,0,0,0-3.93-.94,3.8,3.8,0,0,0-2.67,3,3.16,3.16,0,0,0,0,1.12q.18.84.42,1.67L249.22,280.1l0,.78a4.15,4.15,0,0,1-2.58,3.43l-.83.25-25,.52a7.85,7.85,0,0,0-6.54,3.76,4.17,4.17,0,0,0-.54,1.54,17.7,17.7,0,0,0-.17,2.41l-.13,89a12.56,12.56,0,0,1-2.4,5.95,14.56,14.56,0,0,1-14,5.42,13.64,13.64,0,0,1-11.25-10,6.47,6.47,0,0,1-.15-1q-.12-1.69-.12-3.38l-.11-89.06.07-.94-.06-.3a4,4,0,0,0-7.7-.69,3.18,3.18,0,0,0-.21.94q0,.75,0,1.51v91.12l-.22.8a14.54,14.54,0,0,1-3,5.28A16.75,16.75,0,0,1,156,391.72a15,15,0,0,1-9.77-11.64l-.16-2.14.07-87.83-.88-1.27a8.1,8.1,0,0,0-5.26-2.92l-.89-.06-25.74-.67L113,285a3.63,3.63,0,0,1-1.52-3.43q.22-.89.47-1.77l37.43-134.37a2.73,2.73,0,0,0-.12-1.85,4.7,4.7,0,0,0-.78-1.22,4.2,4.2,0,0,0-5.41-.69A3,3,0,0,0,142,143q-.5,1.28-.87,2.61l-16.8,59.48L118.69,225a1.63,1.63,0,0,1-.21.52,18,18,0,0,1-1.6,2.12,13.91,13.91,0,0,1-14.34,3.92,12.44,12.44,0,0,1-9.14-11.25l.1-1.89,26.43-90.74.6-1a46.08,46.08,0,0,1,38.11-21.79l42.19,0a42.32,42.32,0,0,1,37.7,20.74,16.3,16.3,0,0,1,1.4,3.29Z'/><path class='color-svg' d='M144.92,63.33A34,34,0,1,1,145,65Q144.92,64.17,144.92,63.33Z'/></svg>"}]}

    #pdf_size :
    pdf = Prawn::Document.new(
      page_size: [json[:pdf_size][:width].mm, json[:pdf_size][:height].mm],
      margin: 0
    )

    #product_size & shape :
    pdf.stroke_color "000000"
    pdfBgColor = Prawn::Graphics::Color.rgb2hex(json[:product_size][:bg_color].gsub('rgb(', '').gsub(')', '').split(', '))
    if pdfBgColor != ""
      pdf.fill_color pdfBgColor
    else
      pdf.fill_color 'ffffff'
    end

    if json[:product_size][:shape] == "rounded-rectangle"
      pdf.stroke_rounded_rectangle [json[:product_size][:position][0].mm, json[:product_size][:position][1].mm], json[:product_size][:width].mm, json[:product_size][:height].mm, 10.mm
    elsif json[:product_size][:shape] == "circle"
      pdf.stroke_ellipse [(json[:pdf_size][:width].mm / 2), (json[:pdf_size][:height].mm / 2)], (json[:product_size][:width].mm / 2), (json[:product_size][:height].mm / 2)
    else
      pdf.stroke_rectangle [json[:product_size][:position][0].mm, json[:product_size][:position][1].mm], json[:product_size][:width].mm, json[:product_size][:height].mm
    end

    #product_fix :
    if json[:product_fix]
      json[:product_fix].each do |fix|
        pdf.stroke_color "D40017"
        pdf.stroke_circle [fix[:x].mm, fix[:y].mm], fix[:diam].mm
      end
    end

    # Fonts :
    pdf.font_families.update(
      "Allerta" => {
        normal: Rails.root.join("app/assets/fonts/AllertaStencil-Regular.ttf")
      },
      "Domine" => {
        normal: Rails.root.join("app/assets/fonts/Domine-Regular.ttf"),
        bold: Rails.root.join("app/assets/fonts/Domine-Bold.ttf")
      },
      "KaushanScript" => {
        normal: Rails.root.join("app/assets/fonts/KaushanScript-Regular.ttf")
      },
      "Lato" => {
        normal: Rails.root.join("app/assets/fonts/Lato-Regular.ttf"),
        bold: Rails.root.join("app/assets/fonts/Lato-Bold.ttf")
      },
      "Muli" => {
        normal: Rails.root.join("app/assets/fonts/Muli-Regular.ttf"),
        bold: Rails.root.join("app/assets/fonts/Muli-Bold.ttf")
      },
      "OpenSans" => {
        normal: Rails.root.join("app/assets/fonts/OpenSans-Regular.ttf"),
        bold: Rails.root.join("app/assets/fonts/OpenSans-Bold.ttf")
      },
      "Orbitron" => {
        normal: Rails.root.join("app/assets/fonts/Orbitron-Regular.ttf"),
        bold: Rails.root.join("app/assets/fonts/Orbitron-Bold.ttf")
      },
      "Oswald" => {
        normal: Rails.root.join("app/assets/fonts/Oswald-Medium.ttf"),
        bold: Rails.root.join("app/assets/fonts/Oswald-Bold.ttf")
      },
      "PatrickHand" => {
        normal: Rails.root.join("app/assets/fonts/PatrickHand-Regular.ttf")
      },
      "Quicksand" => {
        normal: Rails.root.join("app/assets/fonts/Quicksand-Regular.ttf"),
        bold: Rails.root.join("app/assets/fonts/Quicksand-Bold.ttf")
      },
      "Satisfy" => {
        normal: Rails.root.join("app/assets/fonts/Satisfy-Regular.ttf")
      },
      "Tinos" => {
        normal: Rails.root.join("app/assets/fonts/Tinos-Regular.ttf"),
        bold: Rails.root.join("app/assets/fonts/Tinos-Bold.ttf"),
      },
      "TitilliumWeb" => {
        normal: Rails.root.join("app/assets/fonts/TitilliumWeb-Regular.ttf"),
        bold: Rails.root.join("app/assets/fonts/TitilliumWeb-Bold.ttf"),
      },
    )

    #text :
    if json[:text]
      json[:text].each do |text_element|
        pdftextColor = Prawn::Graphics::Color.rgb2hex(text_element[:text_color].gsub('rgb(', '').gsub(')', '').split(', '))
        if pdftextColor != ""
          pdf.fill_color pdftextColor
        else
          pdf.fill_color '000000'
        end
        pdf.font_size text_element[:font_size].mm
        pdf.font text_element[:font_family]
        if text_element[:text_align] == 'left'
          pdf.text_box text_element[:content], at: [(text_element[:at][0].mm + 10.mm), ((json[:product_size][:height].mm - text_element[:at][1].mm + 10.mm) - (0.4 * text_element[:font_size].mm))],
                                               width: text_element[:width].mm,
                                               height: text_element[:height].mm,
                                               align: :left,
                                               leading: 7,
                                               overflow: :expand
        elsif text_element[:text_align] == 'center'
          pdf.text_box text_element[:content], at: [(text_element[:at][0].mm + 10.mm), ((json[:product_size][:height].mm - text_element[:at][1].mm + 10.mm) - (0.4 * text_element[:font_size].mm))],
                                               width: text_element[:width].mm,
                                               height: text_element[:height].mm,
                                               align: :center,
                                               leading: 7,
                                               overflow: :expand
        elsif text_element[:text_align] == 'right'
          pdf.text_box text_element[:content], at: [(text_element[:at][0].mm + 10.mm), ((json[:product_size][:height].mm - text_element[:at][1].mm + 10.mm) - (0.4 * text_element[:font_size].mm))],
                                               width: text_element[:width].mm,
                                               height: text_element[:height].mm,
                                               align: :right,
                                               leading: 7,
                                               overflow: :expand
        end
      end
    end

    #svg :
    if json[:svg]
      json[:svg].each do |svg_element|
        pdf.rotate(svg_element[:orientation].to_i, origin: [(svg_element[:at][0].mm + (svg_element[:width].mm / 2) + 10.mm), (json[:product_size][:height].mm - svg_element[:at][1].mm - (svg_element[:width].mm / 2) + 10.mm)] ) do
          pdf.bounding_box([(svg_element[:at][0].mm + 10.mm), (json[:product_size][:height].mm - svg_element[:at][1].mm + 10.mm)], width: svg_element[:width].mm, height: svg_element[:height].mm) do
            pdf.svg svg_element[:source]
          end
        end
      end
    end

    #images :
    if json[:images]
      json[:images].each do |image_element|
        image = @pdf.pictures.find_by(filename: image_element[:fileName])
        pdf.image open(image.photo.url), at: [image_element[:at][0].mm + 10.mm, image_element[:at][1].mm + 10.mm], width: image_element[:width].mm
      end
    end

    #pdf_save :
    send_data pdf.render,
      filename: "export.pdf",
      type: 'application/pdf',
      disposition: 'inline'
  end
end
