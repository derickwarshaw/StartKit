//
//  RepoViewController.swift
//  StartKit
//
//  Created by XueliangZhu on 10/24/16.
//  Copyright © 2016 ThoughtWorks. All rights reserved.
//

import UIKit
import SVProgressHUD

class RepoViewController: UIViewController {
    
    @IBOutlet weak var repoTableView: UITableView!
    fileprivate let repoApiManager = RepoAPIManager()
    fileprivate let viewModel = RepoViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        repoTableView.dataSource = viewModel
        repoTableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let token = KeychainSecretStore().getToken() else {
            showLoginPage()
            return
        }
        fetchRepos(token: token)
    }
    
    private func showLoginPage() {
        let loginVC = UIStoryboard(name: "Login", bundle: nil)
            .instantiateViewController(withIdentifier: "LoginViewController")
        self.present(loginVC, animated: true, completion: nil)
    }
    
    private func fetchRepos(token: String) {
        SVProgressHUD.show()
        repoApiManager.fetchAllRepos(token: token) { [weak self] result in
            switch (result) {
            case RepoResult.success(let repos):
                self?.updateRepoList(repos: repos)
                SVProgressHUD.dismiss()
            case RepoResult.failure:
                SVProgressHUD.showError(withStatus: "Fetch repo failed")
            }
        }
    }
    
    private func updateRepoList(repos: Array<Repo>) {
        viewModel.setRepos(repos)
        repoTableView.reloadData()
    }
}

extension RepoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repo = viewModel.getRepoBy(indexPath)
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SpecificRepoViewController") as! SpecificRepoViewController
        vc.repoName = repo.name!
        self.show(vc, sender: nil)
    }
}

