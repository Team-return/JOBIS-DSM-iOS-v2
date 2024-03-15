import RxFlow

public enum ApplyStep: Step {
    case applyIsRequired(id: Int, name: String, imageURL: String)
}
