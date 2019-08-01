require "prawn/measurement_extensions"

class PdfController < ApplicationController
  def index

    json = {"pdf_size":{"height":120,"width":170},"product_size":{"height":100,"width":150,"position":[85,60],"bg_color":"","shape":"circle"},"product_fix":[{"x":85,"y":105,"diam":2.25},{"x":15,"y":60,"diam":2.25},{"x":155,"y":60,"diam":2.25},{"x":85,"y":15,"diam":2.25}],"fix_stroke":"rgb(255,0,0)","text":[{"height":27.672955974842765,"width":94.0251572327044,"at":[55.0314465408805,38.0503144654088],"text_align":"left","font_size":6.289308176100628,"font_family":"OpenSans","content":"Votre texte icidd dddd ddd ddddd dd dddd dd d ddd ddd dddd ddddd ddddd ddd hhh h"}],"svg":[{"height":51.57232704402515,"width":44.65408805031446,"at":[14.779874213836477,16.352201257861633],"orientation":"","source":"<svg id='GRAVOSIGN_PICTO_3' data-name='Calque 1' xmlns='http://www.w3.org/2000/svg' viewBox='0 0 425.2 425.2'><polygon class='color-svg svg-bank-3' points='364.52 228.69 89.53 358.77 180.6 228.69 89.53 98.61 364.52 228.69'/></svg>"},{"height":20.754716981132074,"width":35.84905660377358,"at":[36.477987421383645,56.91823899371069],"orientation":"90","source":"<svg id='GRAVOSIGN_PICTO_4' data-name='Calque 1' xmlns='http://www.w3.org/2000/svg' viewBox='0 0 425.2 425.2'><polygon class='color-svg svg-bank-4' points='340.06 212.62 127.59 347.9 127.59 68.91 126.99 67.71 340.06 212.62'/></svg>"}]}

    #pdf_size :
    pdf = Prawn::Document.new(
      page_size: [json[:pdf_size][:width].mm, json[:pdf_size][:height].mm],
      margin: 0
    )

    #product_size & shape :
    pdf.stroke_color "000000"
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
        normal: Rails.root.join("app/assets/fonts/Oswald-Regular.ttf"),
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

    #pdf_save :
    send_data pdf.render,
      filename: "export.pdf",
      type: 'application/pdf',
      disposition: 'inline'
  end
end
