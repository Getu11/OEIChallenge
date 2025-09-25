require "rails_helper"

RSpec.describe "Course Selection API", type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json" } }

  describe "criteria: closest" do
    it "selects the edition with the earliest future date" do
      input = {
        "criteria" => ["closest"],
        "editions" => [
          { "date" => "2025-12-01", "courses" => [{ "name" => "Future Course", "type" => "cooperacion" }] },
          { "date" => "2025-10-01", "courses" => [{ "name" => "Soon Course", "type" => "cooperacion" }] }
        ]
      }

      post "/radar", params: input.to_json, headers: headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq([
        { "date" => "2025-10-01", "courses" => ["Soon Course"] }
      ])
    end
  end

  describe "criteria: latest" do
    it "selects the edition with the furthest future date" do
      input = {
        "criteria" => ["latest"],
        "editions" => [
          { "date" => "2025-12-01", "courses" => [{ "name" => "Far Future", "type" => "cooperacion" }] },
          { "date" => "2025-10-01", "courses" => [{ "name" => "Soon", "type" => "cooperacion" }] }
        ]
      }

      post "/radar", params: input.to_json, headers: headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq([
        { "date" => "2025-12-01", "courses" => ["Far Future"] }
      ])
    end
  end

  describe "criteria: type-name" do
    it "filters courses by given type" do
      input = {
        "criteria" => ["type-tupari"],
        "editions" => [
          {
            "date" => "2025-10-01",
            "courses" => [
              { "name" => "Comprendiendo el tupari", "type" => "tupari" },
              { "name" => "Competencias digitales", "type" => "competencias-digitales" }
            ]
          }
        ]
      }

      post "/radar", params: input.to_json, headers: headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq([
        { "date" => "2025-10-01", "courses" => ["Comprendiendo el tupari"] }
      ])
    end
  end

  describe "criteria: school-name" do
    it "filters courses by school" do
      input = {
        "criteria" => ["school-cooperacion"],
        "editions" => [
          {
            "date" => "2025-11-01",
            "courses" => [
              { "name" => "Especialista en cooperación internacional", "type" => "cooperacion" },
              { "name" => "Divulgación científica", "type" => "divulgacion-cientifica" }
            ]
          }
        ]
      }

      post "/radar", params: input.to_json, headers: headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq([
        { "date" => "2025-11-01", "courses" => ["Especialista en cooperación internacional"] }
      ])
    end
  end

  describe "criteria combinations" do
    it "applies closest AND school-cooperacion together" do
      input = {
        "criteria" => ["closest", "school-cooperacion"],
        "editions" => [
          {
            "date" => "2025-11-01",
            "courses" => [
              { "name" => "Especialista en cooperación internacional", "type" => "cooperacion" },
              { "name" => "Divulgación y cooperación de la ciencia", "type" => "divulgacion-cientifica" }
            ]
          },
          {
            "date" => "2025-10-01",
            "courses" => [
              { "name" => "Comprendiendo el tupari", "type" => "tupari" },
              { "name" => "Competencias digitales", "type" => "competencias-digitales" }
            ]
          }
        ]
      }

      post "/radar", params: input.to_json, headers: headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq([
        { "date" => "2025-11-01", "courses" => ["Especialista en cooperación internacional"] }
      ])
    end

    it "applies type filter and then latest" do
      input = {
        "criteria" => ["type-tupari", "latest"],
        "editions" => [
          {
            "date" => "2025-09-01",
            "courses" => [
              { "name" => "Comprendiendo el tupari - Tomo I", "type" => "tupari" }
            ]
          },
          {
            "date" => "2025-12-01",
            "courses" => [
              { "name" => "Comprendiendo el tupari - Tomo II", "type" => "tupari" }
            ]
          }
        ]
      }

      post "/radar", params: input.to_json, headers: headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq([
        { "date" => "2025-12-01", "courses" => ["Comprendiendo el tupari - Tomo II"] }
      ])
    end
  end

  describe "edge cases / non-happy paths" do
    it "returns empty array if no courses match criteria" do
        input = {
        "criteria" => ["school-cooperacion"],
        "editions" => [
            {
            "date" => "2025-10-01",
            "courses" => [
                { "name" => "Comprendiendo el tupari", "type" => "tupari" }
            ]
            }
        ]
        }

        post "/radar", params: input.to_json, headers: headers

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq([])
    end

    it "handles invalid criteria" do
        input = {
        "criteria" => ["unknown-criterion"],
        "editions" => [
            { "date" => "2025-10-01", "courses" => [{ "name" => "Comprendiendo el tupari", "type" => "tupari" }] }
        ]
        }

        post "/radar", params: input.to_json, headers: headers

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to include("error" => "Unknown criteria: unknown-criterion")

    end

    it "handles missing course type gracefully" do
        input = {
        "criteria" => ["type-tupari"],
        "editions" => [
            {
            "date" => "2025-10-01",
            "courses" => [
                { "name" => "Comprendiendo el tupari" } # missing type
            ]
            }
        ]
        }

        post "/radar", params: input.to_json, headers: headers

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({"error" => "Invalid course attributes"})
    end

    it "handles missing course name gracefully" do
        input = {
        "criteria" => ["school-cooperacion"],
        "editions" => [
            {
            "date" => "2025-10-01",
            "courses" => [
                { "type" => "cooperacion" } # missing name
            ]
            }
        ]
        }

        post "/radar", params: input.to_json, headers: headers

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({"error" => "Invalid course attributes"})
    end

    it "handles invalid JSON" do
      # Send invalid JSON (missing closing brace)
      post "/radar", params: '{ "criteria": ["closest"] ', headers: headers

      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)).to include("error" => "Invalid JSON")
    end

    it "handles missing criteria key" do
      input = {
        "editions" => [
          { "date" => "2025-10-01", "courses" => [{ "name" => "Comprendiendo el tupari", "type" => "tupari" }] }
        ]
      }

      post "/radar", params: input.to_json, headers: headers

      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)).to include("error" => "Missing required field: criteria")
    end

    it "handles missing editions key" do
      input = {
        "criteria" => ["closest"]
      }

      post "/radar", params: input.to_json, headers: headers

      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)).to include("error" => "Missing required field: editions")
    end
  end
end
