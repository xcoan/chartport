class PatientsController < ApplicationController
  before_filter :require_user

  def new
    @page_title = "Add Patient Record"
    @patient = Patient.new
  end

  def create
    @patient = current_user.patients.new(patient_params)

    if @patient.save
      redirect_to patient_path(@patient)
    else
      render 'new'
    end
  end

  def edit
    @page_title = "Edit Patient"
    if Patient.exists?(params[:id])
      @patient = Patient.find(params[:id])
    end
  end

  def update
    @patient = Patient.find(params[:id])
    if @patient.update(patient_params)
      redirect_to patient_path(@patient)
    else
      render 'edit'
    end
  end

  def show
    @patient = Patient.find(params[:id])
    @page_title = @patient.name + " record"

    respond_to do | f |
      f.html {
      }

      f.any(:xml, :json) {
        render request.format.to_sym => @patient
      }

      @medications = @patient.medications.all
    end
  end

  def index
    @page_title = "Patients Index"
    @patients = current_user.patients.all.paginate(:page => 1, :per_page => 10)
    if params[:search]
      @patients = current_user.patients.search(params[:search]).order("created_at DESC").paginate(:page => params[:page])
    else
      @patients = current_user.patients.all.order("created_at DESC")
    end

    respond_to do | f |
      f.html {
      }

      f.any(:xml, :json) {
        render request.format.to_sym => @patients
      }
    end
  end

  def adminindex
    @page_title = "Patients Index"
    @patients = Patient.all.paginate(:page => 1, :per_page => 10)
    if params[:search]
      @patients = Patient.search(params[:search]).order("created_at DESC").paginate(:page => params[:page])
    else
      @patients = Patient.all.order("created_at DESC")
    end

    respond_to do | f |
      f.html {
      }

      f.any(:xml, :json) {
        render request.format.to_sym => @patients
      }
    end
  end

  def destroy
    @patient = Patient.find(params[:id])
    @patient.destroy

    redirect_to dashboard_path
  end

  def medicationindex
    @patient = Patient.find(params[:id])
    @medications = @patient.medications.all
  end

  def importsearch
    @page_title = "Patients Index"
    @patients = Patient.where.not(:user_id => current_user)
    if params[:search]
      @patients = Patient.where.not(:user_id => current_user).search(params[:search]).order("created_at DESC").paginate(:page => params[:page])
    else
      @patients = Patient.where.not(:user_id => current_user).order("created_at DESC")
    end
  end

  def importpatient
    @page_title = "Import Patient"
    @user = current_user
    @patient = Patient.find(params[:id])
    @patient.transfer(@user)
  end

  private

  def patient_params
    params.require(:patient).permit(:name, :date_of_birth, :phone_number, :medical_history, :user_id)
  end

end
