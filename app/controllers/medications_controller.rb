class MedicationsController < ApplicationController
  before_action :require_user

  def new
    @patient = Patient.find(params[:patient_id])
    @page_title = "Add Medication for #{@patient.name}"
    @medication = Medication.new
  end

  def create
    @patient = Patient.find(params[:patient_id])
    @page_title = "Add Medication for #{@patient.name}"
    @medication = @patient.medications.new(medication_params)
    if @medication.save
      redirect_to patient_path(@patient)
      @patient = Patient.find(@medication.patient_id)
      @patient.touch
    else
      render 'new'
    end
  end

  def show
    @medication = Medication.find(params[:id])
    @patient = Patient.find(@medication.patient_id)
    @page_title = "#{@patient.name} #{@medication.name} Perscription"
  end

  def edit
    @page_title = "Edit Perscription"
    if Medication.exists?(params[:id])
      @medication = Medication.find(params[:id])
    end
  end

  def update
    @medication = Medication.find(params[:id])
    if @medication.update(medication_params)
      @patient = Patient.find(@medication.patient_id)
      @patient.touch
      redirect_to medication_path(@medication)
    else
      render 'edit'
    end
  end

  def index
    @patient = Patient.find(params[:patient_id])
    @medications = @patient.medications.all
  end

  def destroy
    @medication = Medication.find(params[:id])
    @patient = Patient.find(@medication.patient_id)
    @patient.touch
    @medication.destroy

    redirect_to patient_path(@patient)
  end

  private
  def medication_params
    params.require(:medication).permit(:name, :dosage, :refills, :patient_id)
  end

end
